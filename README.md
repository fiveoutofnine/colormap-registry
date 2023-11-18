<img align="right" width="150" height="150" top="100" src="./assets/terrain_colormap.png">

# Colormap Registry

An on-chain registry for colormaps.

The motivation for this was to provide an easy way to query a palette of colors based on some value. One can [**write util functions**](https://twitter.com/fiveoutofnine/status/1584932730579865600) to generate colors based on some values, but without a registry, the output is quite primitive. [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol) was implemented to allow _any_ possible colormap to be implemented in a streamlined, generalized way. Thus, after computing and registering a colormap, any contract will be able to easily read and use the color value on-chain.

### Colormap identification

Colormaps on the registry are content addressed. This means colormaps are identified via the hash of their definition (see `_computeColormapHash` in [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol), rather than a separate ID or name. It's not the optimal DX, but this way, the registry runs permissionlessly and immutably without an owner.

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

Given some position, the output will be computed via linear interpolations on the segment data for R, G, and B. A maximum of 10 of these 24-bit words fit within 256 bits, so up to 9 segments can be defined.

If you need more granularity or a nonlinear palette function, you may implement [`IPaletteGenerator`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/interfaces/IPaletteGenerator.sol) and define a colormap with that.

## Deployments

The following are deployments of [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol). To see a list of registered colormaps, see [**REGISTERED_COLORMAPS.md**](https://github.com/fiveoutofnine/colormap-registry/blob/main/REGISTERED_COLORMAPS.md).

| Chain   | Chain ID | `v0.0.1`                                                                                                                       | `v0.0.2`                                                                                                                |
| ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Mainnet        | 1        | [`0x0000000012883D1da628e31c0FE52e35DcF95D50`](https://etherscan.io/address/0x0000000012883D1da628e31c0FE52e35DcF95D50)        | [`0x00000000A84FcdF3E9C165e6955945E87dA2cB0D`](https://etherscan.io/address/0x00000000A84FcdF3E9C165e6955945E87dA2cB0D) |
| Goerli         | 5        | [`0x0000000012883D1da628e31c0FE52e35DcF95D50`](https://goerli.etherscan.io/address/0x0000000012883D1da628e31c0FE52e35DcF95D50) | Not deployed                                                                                                            |
| Canto          | 7700     | [`0x0000000012883D1da628e31c0FE52e35DcF95D50`](https://cantoscan.com/address/0x0000000012883D1da628e31c0FE52e35DcF95D50)       | Not deployed                                                                                                            |
| Base           | 8453     | Not deployed                                                                                                                   | [`0x00000000A84FcdF3E9C165e6955945E87dA2cB0D`](https://basescan.org/address/0x00000000A84FcdF3E9C165e6955945E87dA2cB0D) |
| Base Goerli    | 8453     | Not deployed                                                                                                                   | [`0x00000000A84FcdF3E9C165e6955945E87dA2cB0D`](https://goerli.basescan.org/address/0x00000000A84FcdF3E9C165e6955945E87dA2cB0D) |

<details>
    <summary>
        View `v0.0.2` deployment details
    </summary>
The deployments for `v0.0.2` were deployed through the `ImmutableCreate2Factory`at`0x0000000000FFe8B47B3e2130213B802212439497` with the salt

```
0x00000000000000000000000000000000000000008595513898c6a9029eafa090
```

and the bytecode

```
0x608060405234801561001057600080fd5b50611563806100206000396000f3fe608060405234801561001057600080fd5b50600436106100a25760003560e01c80639295f0be11610076578063b5e5d89b1161005b578063b5e5d89b1461018c578063f14b4f3f1461019f578063f5022487146101b257600080fd5b80639295f0be1461014a57806394ab4f431461015d57600080fd5b80623a371d146100a75780633a4a8388146100d05780634420e486146101075780637ed155da1461011c575b600080fd5b6100ba6100b536600461115a565b61020d565b6040516100c79190611197565b60405180910390f35b6100e36100de36600461115a565b6103f9565b6040805160ff948516815292841660208401529216918101919091526060016100c7565b61011a610115366004611227565b6107c5565b005b61012f61012a366004611249565b6107d1565b604080519384526020840192909252908201526060016100c7565b61011a610158366004611371565b610b62565b61012f61016b366004611410565b60006020819052908152604090208054600182015460029092015490919083565b61011a61019a36600461142b565b610b9e565b61011a6101ad3660046114c3565b610bd5565b6101e86101c0366004611410565b60016020526000908152604090205473ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020016100c7565b6060600080600061021e86866103f9565b919450925090507f3031323334353637383941424344454600000000000000000000000000000000600f600485901c166020811061025e5761025e6114df565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f851660208110610297576102976114df565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f600486901c16602081106102d4576102d46114df565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f86166020811061030d5761030d6114df565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f600487901c166020811061034a5761034a6114df565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f871660208110610383576103836114df565b6040517fff00000000000000000000000000000000000000000000000000000000000000978816602082015295871660218701529386166022860152918516602385015284166024840152901a60f81b909116602582015260260160405160208183030381529060405293505050505b92915050565b7fffffffffffffffff000000000000000000000000000000000000000000000000821660009081526020818152604080832081516060810183528154808252600183015494820194909452600290910154918101919091528291829186911580156104a957507fffffffffffffffff000000000000000000000000000000000000000000000000821660009081526001602052604090205473ffffffffffffffffffffffffffffffffffffffff16155b15610509576040517f5cc91f7e0000000000000000000000000000000000000000000000000000000081527fffffffffffffffff000000000000000000000000000000000000000000000000831660048201526024015b60405180910390fd5b7fffffffffffffffff000000000000000000000000000000000000000000000000871660009081526001602052604090205473ffffffffffffffffffffffffffffffffffffffff168015610734576040517ff471d7ac000000000000000000000000000000000000000000000000000000008152660deea55900646460ff89168102600483018190529173ffffffffffffffffffffffffffffffffffffffff84169063f471d7ac90602401602060405180830381865afa1580156105d1573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105f5919061150e565b8161060257610602611527565b04660deea5590064648373ffffffffffffffffffffffffffffffffffffffff1663e420264a846040518263ffffffff1660e01b815260040161064691815260200190565b602060405180830381865afa158015610663573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610687919061150e565b8161069457610694611527565b04660deea5590064648473ffffffffffffffffffffffffffffffffffffffff1663cd580ff3856040518263ffffffff1660e01b81526004016106d891815260200190565b602060405180830381865afa1580156106f5573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610719919061150e565b8161072657610726611527565b0496509650965050506107bc565b7fffffffffffffffff00000000000000000000000000000000000000000000000088166000908152602081815260409182902082516060810184528154808252600183015493820193909352600290910154928101929092526107979089610bde565b6107a582602001518a610bde565b6107b383604001518b610bde565b96509650965050505b50509250925092565b6107ce81610c84565b50565b7fffffffffffffffff0000000000000000000000000000000000000000000000008216600090815260208181526040808320815160608101835281548082526001830154948201949094526002909101549181019190915282918291869115801561088157507fffffffffffffffff000000000000000000000000000000000000000000000000821660009081526001602052604090205473ffffffffffffffffffffffffffffffffffffffff16155b156108dc576040517f5cc91f7e0000000000000000000000000000000000000000000000000000000081527fffffffffffffffff00000000000000000000000000000000000000000000000083166004820152602401610500565b7fffffffffffffffff000000000000000000000000000000000000000000000000871660009081526001602052604090205473ffffffffffffffffffffffffffffffffffffffff168015610ae3576040517ff471d7ac0000000000000000000000000000000000000000000000000000000081526004810188905273ffffffffffffffffffffffffffffffffffffffff82169063f471d7ac90602401602060405180830381865afa158015610995573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109b9919061150e565b6040517fe420264a0000000000000000000000000000000000000000000000000000000081526004810189905273ffffffffffffffffffffffffffffffffffffffff83169063e420264a90602401602060405180830381865afa158015610a24573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a48919061150e565b6040517fcd580ff3000000000000000000000000000000000000000000000000000000008152600481018a905273ffffffffffffffffffffffffffffffffffffffff84169063cd580ff390602401602060405180830381865afa158015610ab3573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610ad7919061150e565b955095509550506107bc565b7fffffffffffffffff0000000000000000000000000000000000000000000000008816600090815260208181526040918290208251606081018452815480825260018301549382019390935260029091015492810192909252610b469089610d41565b610b5482602001518a610d41565b6107b383604001518b610d41565b805160005b81811015610b9957610b91838281518110610b8457610b846114df565b6020026020010151610de3565b600101610b67565b505050565b805160005b81811015610b9957610bcd838281518110610bc057610bc06114df565b6020026020010151610c84565b600101610ba3565b6107ce81610de3565b60005b8160ff16602884901c60ff161015610bff57601883901c9250610be1565b62ffffff80841690601885901c1660ff601086901c811690602887901c81169080881690602089901c8116908816849003848403838310610c5f5780828585030281610c4d57610c4d611527565b048401985050505050505050506103f3565b80828486030281610c7257610c72611527565b049093039a9950505050505050505050565b6000610c8f82610ead565b7fffffffffffffffff000000000000000000000000000000000000000000000000811660008181526001602090815260409182902080547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff88169081179091558251938452908301529192507f51ab537ce60b5d5811824fe7db687b6ec835ba55ec37a2eadfd81c894154983b91015b60405180910390a15050565b6000670de0b6b3a763ff9c8211610d585781610d62565b670de0b6b3a763ff9c5b91505b81660deea559006464602885901c60ff16021015610d8957601883901c9250610d65565b62ffffff80841690601885901c1660ff601086901c8116660deea55900646490810291602888901c811682029181891681029160208a901c1602838803848403838310610c5f5780828585030281610c4d57610c4d611527565b6000610dee82610f06565b9050610dfd8260000151610f35565b610e0a8260200151610f35565b610e178260400151610f35565b7fffffffffffffffff0000000000000000000000000000000000000000000000008116600081815260208181526040918290208551815585820180516001830155868401805160029093019290925583519485528651928501929092529051918301919091525160608201527ff5665410b696554012166bb4b875c112e43a1e873201a48c6e194010272ee23390608001610d35565b6040517fffffffffffffffffffffffffffffffffffffffff000000000000000000000000606083901b16602082015260009081906034015b6040516020818303038152906040528051906020012090506103f38161101e565b805160208083015160408085015181519384019490945282015260608101919091526000908190608001610ee5565b60ff601082901c168015610f78576040517f524661ea00000000000000000000000000000000000000000000000000000000815260048101839052602401610500565b601882901c5b8015610fdb5760ff601082901c16828111610fc8576040517f524661ea00000000000000000000000000000000000000000000000000000000815260048101859052602401610500565b5060ff601082901c16915060181c610f7e565b5060ff81101561101a576040517f524661ea00000000000000000000000000000000000000000000000000000000815260048101839052602401610500565b5050565b7fffffffffffffffff00000000000000000000000000000000000000000000000081166000908152602081815260409182902082516060810184528154808252600183015493820193909352600290910154928101929092521515806110ca57507fffffffffffffffff000000000000000000000000000000000000000000000000821660009081526001602052604090205473ffffffffffffffffffffffffffffffffffffffff1615155b1561101a576040517f2996eda90000000000000000000000000000000000000000000000000000000081527fffffffffffffffff00000000000000000000000000000000000000000000000083166004820152602401610500565b80357fffffffffffffffff0000000000000000000000000000000000000000000000008116811461115557600080fd5b919050565b6000806040838503121561116d57600080fd5b61117683611125565b9150602083013560ff8116811461118c57600080fd5b809150509250929050565b600060208083528351808285015260005b818110156111c4578581018301518582016040015282016111a8565b5060006040828601015260407fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f8301168501019250505092915050565b803573ffffffffffffffffffffffffffffffffffffffff8116811461115557600080fd5b60006020828403121561123957600080fd5b61124282611203565b9392505050565b6000806040838503121561125c57600080fd5b61126583611125565b946020939093013593505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b604051601f82017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe016810167ffffffffffffffff811182821017156112e9576112e9611273565b604052919050565b600067ffffffffffffffff82111561130b5761130b611273565b5060051b60200190565b60006060828403121561132757600080fd5b6040516060810181811067ffffffffffffffff8211171561134a5761134a611273565b80604052508091508235815260208301356020820152604083013560408201525092915050565b6000602080838503121561138457600080fd5b823567ffffffffffffffff81111561139b57600080fd5b8301601f810185136113ac57600080fd5b80356113bf6113ba826112f1565b6112a2565b818152606091820283018401918482019190888411156113de57600080fd5b938501935b83851015611404576113f58986611315565b835293840193918501916113e3565b50979650505050505050565b60006020828403121561142257600080fd5b61124282611125565b6000602080838503121561143e57600080fd5b823567ffffffffffffffff81111561145557600080fd5b8301601f8101851361146657600080fd5b80356114746113ba826112f1565b81815260059190911b8201830190838101908783111561149357600080fd5b928401925b828410156114b8576114a984611203565b82529284019290840190611498565b979650505050505050565b6000606082840312156114d557600080fd5b6112428383611315565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60006020828403121561152057600080fd5b5051919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fdfea164736f6c6343000815000a
```

which was compiled with the compiler version `v0.8.21+commit.d9974bed` and `1000000` optimizer runs.

</details>

<details>
    <summary>
        View `v0.0.1` deployment details
    </summary>
The deployments for `v0.0.1` were deployed through the `ImmutableCreate2Factory`at`0x0000000000FFe8B47B3e2130213B802212439497` with the salt

```
0x00000000000000000000000000000000000000000e558e93fbb8d803204fdbdb
```

and the bytecode

```
0x608060405234801561001057600080fd5b50611068806100206000396000f3fe608060405234801561001057600080fd5b506004361061007d5760003560e01c8063730236ca1161005b578063730236ca14610125578063f14b4f3f14610145578063f948433014610158578063fd6d7d061461018757600080fd5b8063172327cd146100825780634420e486146100b55780637168be56146100ca575b600080fd5b610095610090366004610e47565b6101be565b604080519384526020840192909252908201526060015b60405180910390f35b6100c86100c3366004610e69565b6104b9565b005b6101006100d8366004610ea6565b60016020526000908152604090205473ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020016100ac565b610138610133366004610ebf565b610553565b6040516100ac9190610ef5565b6100c8610153366004610f61565b61073f565b610095610166366004610ea6565b60006020819052908152604090208054600182015460029092015490919083565b61019a610195366004610ebf565b6107e6565b6040805160ff948516815292841660208401529216918101919091526060016100ac565b6000828152602081815260408083208151606081018352815480825260018301549482019490945260029091015491810191909152829182918691158015610228575060008281526001602052604090205473ffffffffffffffffffffffffffffffffffffffff16155b15610267576040517f6ed9c4db000000000000000000000000000000000000000000000000000000008152600481018390526024015b60405180910390fd5b60008781526001602052604090205473ffffffffffffffffffffffffffffffffffffffff16801561044b576040517ff471d7ac0000000000000000000000000000000000000000000000000000000081526004810188905273ffffffffffffffffffffffffffffffffffffffff82169063f471d7ac90602401602060405180830381865afa1580156102fd573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906103219190610fe4565b6040517fe420264a0000000000000000000000000000000000000000000000000000000081526004810189905273ffffffffffffffffffffffffffffffffffffffff83169063e420264a90602401602060405180830381865afa15801561038c573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906103b09190610fe4565b6040517fcd580ff3000000000000000000000000000000000000000000000000000000008152600481018a905273ffffffffffffffffffffffffffffffffffffffff84169063cd580ff390602401602060405180830381865afa15801561041b573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061043f9190610fe4565b955095509550506104b0565b60008881526020818152604091829020825160608101845281548082526001830154938201939093526002909101549281019290925261048b9089610aee565b61049982602001518a610aee565b6104a783604001518b610aee565b96509650965050505b50509250925092565b60006104c482610bc7565b60008181526001602090815260409182902080547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff87169081179091558251848152918201529192507ff2d00828f226f5dd23b91aed5ba27bfd61a57ac84aed836d9171b2c08771f21091015b60405180910390a15050565b6060600080600061056486866107e6565b919450925090507f3031323334353637383941424344454600000000000000000000000000000000600f600485901c16602081106105a4576105a4610ffd565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f8516602081106105dd576105dd610ffd565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f600486901c166020811061061a5761061a610ffd565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f86166020811061065357610653610ffd565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f600487901c166020811061069057610690610ffd565b1a60f81b7f3031323334353637383941424344454600000000000000000000000000000000600f8716602081106106c9576106c9610ffd565b6040517fff00000000000000000000000000000000000000000000000000000000000000978816602082015295871660218701529386166022860152918516602385015284166024840152901a60f81b909116602582015260260160405160208183030381529060405293505050505b92915050565b600061074a82610c20565b90506107598260000151610c4f565b6107668260200151610c4f565b6107738260400151610c4f565b600081815260208181526040918290208451815584820180516001830155858401805160029093019290925583518581528651938101939093525192820192909252905160608201527f9b14bb94e1465f1fcfb06453c86dce8b6cb7240b254eea39298cc71ca5168da690608001610547565b6000828152602081815260408083208151606081018352815480825260018301549482019490945260029091015491810191909152829182918691158015610850575060008281526001602052604090205473ffffffffffffffffffffffffffffffffffffffff16155b1561088a576040517f6ed9c4db0000000000000000000000000000000000000000000000000000000081526004810183905260240161025e565b60008781526001602052604090205473ffffffffffffffffffffffffffffffffffffffff168015610a92576040517ff471d7ac000000000000000000000000000000000000000000000000000000008152660deea55900646460ff89168102600483018190529173ffffffffffffffffffffffffffffffffffffffff84169063f471d7ac90602401602060405180830381865afa15801561092f573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109539190610fe4565b816109605761096061102c565b04660deea5590064648373ffffffffffffffffffffffffffffffffffffffff1663e420264a846040518263ffffffff1660e01b81526004016109a491815260200190565b602060405180830381865afa1580156109c1573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906109e59190610fe4565b816109f2576109f261102c565b04660deea5590064648473ffffffffffffffffffffffffffffffffffffffff1663cd580ff3856040518263ffffffff1660e01b8152600401610a3691815260200190565b602060405180830381865afa158015610a53573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a779190610fe4565b81610a8457610a8461102c565b0496509650965050506104b0565b600088815260208181526040918290208251606081018452815480825260018301549382019390935260029091015492810192909252610ad29089610d38565b610ae082602001518a610d38565b6104a783604001518b610d38565b6000670de0b6b3a763ff9c8211610b055781610b0f565b670de0b6b3a763ff9c5b91505b81660deea559006464602885901c60ff16021015610b3657601883901c9250610b12565b62ffffff80841690601885901c1660ff601086901c8116660deea55900646490810291602888901c811682029181891681029160208a901c1602838803848403838310610ba25780828585030281610b9057610b9061102c565b04840198505050505050505050610739565b80828486030281610bb557610bb561102c565b049093039a9950505050505050505050565b6040517fffffffffffffffffffffffffffffffffffffffff000000000000000000000000606083901b16602082015260009081906034015b60405160208183030381529060405280519060200120905061073981610da7565b805160208083015160408085015181519384019490945282015260608101919091526000908190608001610bff565b60ff601082901c168015610c92576040517f524661ea0000000000000000000000000000000000000000000000000000000081526004810183905260240161025e565b601882901c5b8015610cf55760ff601082901c16828111610ce2576040517f524661ea0000000000000000000000000000000000000000000000000000000081526004810185905260240161025e565b5060ff601082901c16915060181c610c98565b5060ff811015610d34576040517f524661ea0000000000000000000000000000000000000000000000000000000081526004810183905260240161025e565b5050565b60005b8160ff16602884901c60ff161015610d5957601883901c9250610d3b565b62ffffff80841690601885901c1660ff601086901c811690602887901c81169080881690602089901c8116908816849003848403838310610ba25780828585030281610b9057610b9061102c565b600081815260208181526040918290208251606081018452815480825260018301549382019390935260029091015492810192909252151580610e0d575060008281526001602052604090205473ffffffffffffffffffffffffffffffffffffffff1615155b15610d34576040517fea82ade20000000000000000000000000000000000000000000000000000000081526004810183905260240161025e565b60008060408385031215610e5a57600080fd5b50508035926020909101359150565b600060208284031215610e7b57600080fd5b813573ffffffffffffffffffffffffffffffffffffffff81168114610e9f57600080fd5b9392505050565b600060208284031215610eb857600080fd5b5035919050565b60008060408385031215610ed257600080fd5b82359150602083013560ff81168114610eea57600080fd5b809150509250929050565b600060208083528351808285015260005b81811015610f2257858101830151858201604001528201610f06565b5060006040828601015260407fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f8301168501019250505092915050565b600060608284031215610f7357600080fd5b6040516060810181811067ffffffffffffffff82111715610fbd577f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b80604052508235815260208301356020820152604083013560408201528091505092915050565b600060208284031215610ff657600080fd5b5051919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fdfea164736f6c6343000811000a
```

which was compiled with the compiler version `v0.8.17+commit.8df45f5f` and `1000000` optimizer runs.

</details>

If you deploy the registry to other EVM chains, please make a PR to add it here.

## Usage

### Reading a colormap

The registry allows querying values with either a `uint8` in $[0, 255]$ or a 18 decimal fixed point number in $[0, 1]$ for extra resolution (see comments in [`ColormapRegistry`](https://github.com/fiveoutofnine/colormap-registry/blob/main/src/ColormapRegistry.sol) for more info).

To read a color's R, G, and B values from a colormap 42.195% along the way, you can run the following:

```sol
(uint256 r, uint256 g, uint256 b) = ColormapRegistry.getValue({
    _hash: "COLORMAP_HASH",
    _position: 0.42195e18
});
```

To read a color's R, G, and B values from a colormap $\frac{42}{255}$ along the way, you can run the following:

```sol
(uint8 r, uint8 g, uint8 b) = ColormapRegistry.getValueAsUint8({ _hash: "COLORMAP_HASH", _position: 42 });
```

To read a color as a 24-bit hexstring from a colormap $\frac{42}{255}$ along the way, you can run the following:

```sol
string memory colorHex = ColormapRegistry.getValueAsHexString({ _hash: "COLORMAP_HASH", _position: 42 });
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

> **Note**
> The registry (`>=v0.0.2`) also comes with batch register functions `batchRegister` via palette generator and segment data.

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

### Verifying `ColormapRegistry`

To verify the contract on Etherscan, run the following command:

```sh
forge verify-contract --chain-id $CHAIN_ID --num-of-optimizations 1000000 --watch --compiler-version $COMPILER_VERSION $DEPLOY_ADDRESS src/ColormapRegistry.sol:ColormapRegistry $ETHERSCAN_KEY
```

## Credits

This project was built by [**fiveoutofnine**](https://twitter.com/fiveoutofnine) for [**Curta**](https://curta.wtf).

The colormaps added in [`DeployScript`](https://github.com/fiveoutofnine/colormap-registry/blob/main/script/Deploy.s.sol) were adapted from [**matplotlib**](https://github.com/matplotlib/matplotlib) via [`generate_cmaps.py`](https://github.com/fiveoutofnine/colormap-registry/blob/main/generate_cmaps.py).

## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
