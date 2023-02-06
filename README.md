# Colormap Registry

An on-chain registry for colormaps.

The motivation for this was to provide an easy way to query a palette of colors based on some value. One can [**write util functions**](https://twitter.com/fiveoutofnine/status/1584932730579865600) to generate colors based on some values, but without a registry, the output is quite primitive. [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol) was implemented to allow for _any_ possible colormap to be implemented in a generalized way. Thus, after computing and registering a colormap, any contract will be able to easily read and use the color value on-chain.

### Colormap identification

Colormaps on the registry are content addressed. This means colormaps are identified via the hash of their definition (see `_computeColormapHash` in [`ColormapRegistry`](<(https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol)>)), rather than a separate ID or name. It's not the optimal DX, but this way, the registry runs permissionlessly and immutably without an owner.

### Colormap definition

There are 2 ways to define a colormap:

1. via segment data
2. or via a [**palette generator**](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/interfaces/IPaletteGenerator.sol).

Segment data contains 1 `uint256` each for red, green, and blue describing their intensity values along the colormap. Each `uint256` contains 24-bit words bitpacked together with the following structure (bits are right-indexed):

| Bits      | Meaning                                              |
| --------- | ---------------------------------------------------- |
| `23 - 16` | Position in the colormap the segment begins from     |
| `15 - 08` | Intensity of R, G, or B the previous segment ends at |
| `07 - 00` | Intensity of R, G, or B the next segment starts at   |

Given some position, the output will be computed via linear interpolations on the segment data for R, G, and B. A maximum of 10 of these segments fit within 256 bits, so up to 9 segments can be defined.

If you need more granularity or a nonlinear palette function, you may implement [`IPaletteGenerator`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/interfaces/IPaletteGenerator.sol) and define a colormap with that.

## Usage

### Reading a colormap

The registry allows querying values with either a `uint8` in $[0, 255]$ or a 18 decimal fixed point number in $[0, 1]$ for extra resolution (see comments in [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol) for more info).

To read a color's R, G, and B values from a colormap 42.195% along the way, you can run the following:

```sol
(uint256 r, uint256 g, uint256 b) = ColormapRegistry.getValue({
    _colormapHash: "COLORMAP_HASH",
    _position: 0.42195e18
});
```

To read a color's R, G, and B values from a colormap $\frac{42}{255}$ along the way, you can run the following:

```sol
(uint8 r, uint8 g, uint8 b) = ColormapRegistry.getValueAsUint8({ _colormapHash: "COLORMAP_HASH", _position: 42 });
```

To read a color as a 24-bit hexstring from a colormap $\frac{42}{255}$ along the way, you can run the following:

```sol
string memory colorHex = ColormapRegistry.getValueAsHexString({ _colormapHash: "COLORMAP_HASH", _position: 42 });
```

### Registering a colormap

To register a colormap via segment data, compute the segment data following the representation defined by the registry. Then, run the following:

```ts
ColormapRegistry.register(segmentData);
```

To register a colormap via a palette generator, first implement and deploy an instance of [`IPaletteGenerator`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/interfaces/IPaletteGenerator.sol). Then, run the following:

```ts
ColormapRegistry.register(paletteGenerator);
```

## Local development

This project uses [**Foundry**](https://github.com/foundry-rs/foundry) as its development/testing framework.

### Installation

First, make sure you have Foundry installed. Then, run the following commands to clone the repo and install its dependencies:

```sh
git clone https://github.com/fiveoutofnine/colormap-registry.git
cd colormap-registry
forge install
```

### Testing

To run tests, run the following command:

```sh
forge test
```

### Coverage

To view coverage, run the following command:

```sh
forge coverage
```

To generate a report, run the following command:

```sh
forge coverage --report lcov
```

> **Note**
> It may be helpful to use an extension like [**Coverage Gutters**](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters) to display the coverage over the code.

### Deploying

#### 1. Set environment variables

Create a file named `.env` at the root of the project and copy the contents of `.env.example` into it. Then, fill out each of the variables:

| Variable          | Description                                                              |
| ----------------- | ------------------------------------------------------------------------ |
| `RPC_URL_MAINNET` | An RPC endpoint for mainnet                                              |
| `ETHERSCAN_KEY`   | An [**Etherscan**](https://etherscan.io) API key for verifying contracts |

#### 2. Run commands to run deploy scripts

To deploy to mainnet, run the following command:

```sh
source .env # Load environment variables
forge script script/deploy/Deploy.s.sol:Deploy -f mainnet --broadcast --verify
```

## Credits

This project was built by [**fiveoutofnine**](https://twitter.com/fiveoutofnine) for [**Curta**](https://curta.wtf).
