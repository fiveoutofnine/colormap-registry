import math

# Colormap values adapted from
# https://github.com/matplotlib/matplotlib/blob/main/lib/matplotlib/_cm.py

_binary_data = {
    'red':    ((0., 1., 1.), (1., 0., 0.)),
    'green':  ((0., 1., 1.), (1., 0., 0.)),
    'blue':   ((0., 1., 1.), (1., 0., 0.))
}

_autumn_data = {'red':   ((0., 1.0, 1.0), (1.0, 1.0, 1.0)),
                'green': ((0., 0., 0.), (1.0, 1.0, 1.0)),
                'blue':  ((0., 0., 0.), (1.0, 0., 0.))}

_bone_data = {'red':   ((0., 0., 0.),
                        (0.746032, 0.652778, 0.652778),
                        (1.0, 1.0, 1.0)),
              'green': ((0., 0., 0.),
                        (0.365079, 0.319444, 0.319444),
                        (0.746032, 0.777778, 0.777778),
                        (1.0, 1.0, 1.0)),
              'blue':  ((0., 0., 0.),
                        (0.365079, 0.444444, 0.444444),
                        (1.0, 1.0, 1.0))}

_cool_data = {'red':   ((0., 0., 0.), (1.0, 1.0, 1.0)),
              'green': ((0., 1., 1.), (1.0, 0.,  0.)),
              'blue':  ((0., 1., 1.), (1.0, 1.,  1.))}

_copper_data = {'red':   ((0., 0., 0.),
                          (0.809524, 1.000000, 1.000000),
                          (1.0, 1.0, 1.0)),
                'green': ((0., 0., 0.),
                          (1.0, 0.7812, 0.7812)),
                'blue':  ((0., 0., 0.),
                          (1.0, 0.4975, 0.4975))}

_binary_data = {
    'red':    ((0., 1., 1.), (1., 0., 0.)),
    'green':  ((0., 1., 1.), (1., 0., 0.)),
    'blue':   ((0., 1., 1.), (1., 0., 0.))
}

_autumn_data = {'red':   ((0., 1.0, 1.0), (1.0, 1.0, 1.0)),
                'green': ((0., 0., 0.), (1.0, 1.0, 1.0)),
                'blue':  ((0., 0., 0.), (1.0, 0., 0.))}

_bone_data = {'red':   ((0., 0., 0.),
                        (0.746032, 0.652778, 0.652778),
                        (1.0, 1.0, 1.0)),
              'green': ((0., 0., 0.),
                        (0.365079, 0.319444, 0.319444),
                        (0.746032, 0.777778, 0.777778),
                        (1.0, 1.0, 1.0)),
              'blue':  ((0., 0., 0.),
                        (0.365079, 0.444444, 0.444444),
                        (1.0, 1.0, 1.0))}

_cool_data = {'red':   ((0., 0., 0.), (1.0, 1.0, 1.0)),
              'green': ((0., 1., 1.), (1.0, 0.,  0.)),
              'blue':  ((0., 1., 1.), (1.0, 1.,  1.))}

_copper_data = {'red':   ((0., 0., 0.),
                          (0.809524, 1.000000, 1.000000),
                          (1.0, 1.0, 1.0)),
                'green': ((0., 0., 0.),
                          (1.0, 0.7812, 0.7812)),
                'blue':  ((0., 0., 0.),
                          (1.0, 0.4975, 0.4975))}

_terrain_data = (
    (0.00, (0.2, 0.2, 0.6)),
    (0.15, (0.0, 0.6, 1.0)),
    (0.25, (0.0, 0.8, 0.4)),
    (0.50, (1.0, 1.0, 0.6)),
    (0.75, (0.5, 0.36, 0.33)),
    (1.00, (1.0, 1.0, 1.0)))

_gray_data = {'red':   ((0., 0, 0), (1., 1, 1)),
              'green': ((0., 0, 0), (1., 1, 1)),
              'blue':  ((0., 0, 0), (1., 1, 1))}

_hot_data = {'red':   ((0., 0.0416, 0.0416),
                       (0.365079, 1.000000, 1.000000),
                       (1.0, 1.0, 1.0)),
             'green': ((0., 0., 0.),
                       (0.365079, 0.000000, 0.000000),
                       (0.746032, 1.000000, 1.000000),
                       (1.0, 1.0, 1.0)),
             'blue':  ((0., 0., 0.),
                       (0.746032, 0.000000, 0.000000),
                       (1.0, 1.0, 1.0))}
_hsv_data = {'red':   ((0., 1., 1.),
                       (0.158730, 1.000000, 1.000000),
                       (0.174603, 0.968750, 0.968750),
                       (0.333333, 0.031250, 0.031250),
                       (0.349206, 0.000000, 0.000000),
                       (0.666667, 0.000000, 0.000000),
                       (0.682540, 0.031250, 0.031250),
                       (0.841270, 0.968750, 0.968750),
                       (0.857143, 1.000000, 1.000000),
                       (1.0, 1.0, 1.0)),
             'green': ((0., 0., 0.),
                       (0.158730, 0.937500, 0.937500),
                       (0.174603, 1.000000, 1.000000),
                       (0.507937, 1.000000, 1.000000),
                       (0.666667, 0.062500, 0.062500),
                       (0.682540, 0.000000, 0.000000),
                       (1.0, 0., 0.)),
             'blue':  ((0., 0., 0.),
                       (0.333333, 0.000000, 0.000000),
                       (0.349206, 0.062500, 0.062500),
                       (0.507937, 1.000000, 1.000000),
                       (0.841270, 1.000000, 1.000000),
                       (0.857143, 0.937500, 0.937500),
                       (1.0, 0.09375, 0.09375))}

_jet_data = {'red':   ((0.00, 0, 0),
                       (0.35, 0, 0),
                       (0.66, 1, 1),
                       (0.89, 1, 1),
                       (1.00, 0.5, 0.5)),
             'green': ((0.000, 0, 0),
                       (0.125, 0, 0),
                       (0.375, 1, 1),
                       (0.640, 1, 1),
                       (0.910, 0, 0),
                       (1.000, 0, 0)),
             'blue':  ((0.00, 0.5, 0.5),
                       (0.11, 1, 1),
                       (0.34, 1, 1),
                       (0.65, 0, 0),
                       (1.00, 0, 0))}
_spring_data = {'red':   ((0., 1., 1.), (1.0, 1.0, 1.0)),
                'green': ((0., 0., 0.), (1.0, 1.0, 1.0)),
                'blue':  ((0., 1., 1.), (1.0, 0.0, 0.0))}


_summer_data = {'red':   ((0., 0., 0.), (1.0, 1.0, 1.0)),
                'green': ((0., 0.5, 0.5), (1.0, 1.0, 1.0)),
                'blue':  ((0., 0.4, 0.4), (1.0, 0.4, 0.4))}


_winter_data = {'red':   ((0., 0., 0.), (1.0, 0.0, 0.0)),
                'green': ((0., 0., 0.), (1.0, 1.0, 1.0)),
                'blue':  ((0., 1., 1.), (1.0, 0.5, 0.5))}

_gist_rainbow_data = (
    (0.000, (1.00, 0.00, 0.16)),
    (0.030, (1.00, 0.00, 0.00)),
    (0.215, (1.00, 1.00, 0.00)),
    (0.400, (0.00, 1.00, 0.00)),
    (0.586, (0.00, 1.00, 1.00)),
    (0.770, (0.00, 0.00, 1.00)),
    (0.954, (1.00, 0.00, 1.00)),
    (1.000, (1.00, 0.00, 0.75))
)

_gist_stern_data = {
    'red': (
        (0.000, 0.000, 0.000), (0.0547, 1.000, 1.000),
        (0.250, 0.027, 0.250),  # (0.2500, 0.250, 0.250),
        (1.000, 1.000, 1.000)),
    'green': ((0, 0, 0), (1, 1, 1)),
    'blue': (
            (0.000, 0.000, 0.000), (0.500, 1.000, 1.000),
            (0.735, 0.000, 0.000), (1.000, 1.000, 1.000))
}

_CMRmap_data = {'red':    ((0.000, 0.00, 0.00),
                           (0.125, 0.15, 0.15),
                           (0.250, 0.30, 0.30),
                           (0.375, 0.60, 0.60),
                           (0.500, 1.00, 1.00),
                           (0.625, 0.90, 0.90),
                           (0.750, 0.90, 0.90),
                           (0.875, 0.90, 0.90),
                           (1.000, 1.00, 1.00)),
                'green':  ((0.000, 0.00, 0.00),
                           (0.125, 0.15, 0.15),
                           (0.250, 0.15, 0.15),
                           (0.375, 0.20, 0.20),
                           (0.500, 0.25, 0.25),
                           (0.625, 0.50, 0.50),
                           (0.750, 0.75, 0.75),
                           (0.875, 0.90, 0.90),
                           (1.000, 1.00, 1.00)),
                'blue':   ((0.000, 0.00, 0.00),
                           (0.125, 0.50, 0.50),
                           (0.250, 0.75, 0.75),
                           (0.375, 0.50, 0.50),
                           (0.500, 0.15, 0.15),
                           (0.625, 0.00, 0.00),
                           (0.750, 0.10, 0.10),
                           (0.875, 0.50, 0.50),
                           (1.000, 1.00, 1.00))}

_wistia_data = {
    'red': [(0.0, 0.8941176470588236, 0.8941176470588236),
            (0.25, 1.0, 1.0),
            (0.5, 1.0, 1.0),
            (0.75, 1.0, 1.0),
            (1.0, 0.9882352941176471, 0.9882352941176471)],
    'green': [(0.0, 1.0, 1.0),
              (0.25, 0.9098039215686274, 0.9098039215686274),
              (0.5, 0.7411764705882353, 0.7411764705882353),
              (0.75, 0.6274509803921569, 0.6274509803921569),
              (1.0, 0.4980392156862745, 0.4980392156862745)],
    'blue': [(0.0, 0.47843137254901963, 0.47843137254901963),
             (0.25, 0.10196078431372549, 0.10196078431372549),
             (0.5, 0.0, 0.0),
             (0.75, 0.0, 0.0),
             (1.0, 0.0, 0.0)],
}

cmaps = {
    'CMRmap': _CMRmap_data,
    'Wistia': _wistia_data,
    'autumn': _autumn_data,
    'binary': _binary_data,
    'bone': _bone_data,
    'cool': _cool_data,
    'copper': _copper_data,
    'gist_rainbow': _gist_rainbow_data,
    'gist_stern': _gist_stern_data,
    'gray': _gray_data,
    'hot': _hot_data,
    'hsv': _hsv_data,
    'jet': _jet_data,
    'spring': _spring_data,
    'summer': _summer_data,
    'terrain': _terrain_data,
    'winter': _winter_data,
}

valid_colormap_count, solidity_source = 0, ""

for i, (name, data) in enumerate(cmaps.items()):
    is_valid = True
    code = f"\n// ``{name}'' colormap.\n"

    if 'red' in data:
        for color, color_data in data.items():
            if len(color_data) > 10:
                is_valid = False
                break

            bitmap = 0
            for j, entry in enumerate(color_data):
                onchain_representation = (math.floor(entry[0] * 0xFF) << 16)\
                    | (math.floor(entry[1] * 0xFF) << 8)\
                    | math.floor(entry[2] * 0xFF)
                bitmap |= onchain_representation << (24 * j)

            code += f"segmentDataArray[{i}].{color[0]} = 0x{hex(bitmap).upper()[2:]};\n"
    else:
        if len(data) > 10:
            is_valid = False
            continue

        r_bitmap, g_bitmap, b_bitmap = 0, 0, 0
        for j, entry in enumerate(data):
            r_bitmap |= (math.floor(entry[0] * 0xFF) << (16 + 24 * j))
            g_bitmap |= (math.floor(entry[0] * 0xFF) << (16 + 24 * j))
            b_bitmap |= (math.floor(entry[0] * 0xFF) << (16 + 24 * j))

            r_bitmap |= (math.floor(entry[1][0] * 0xFF) << (8 + 24 * j))
            g_bitmap |= (math.floor(entry[1][1] * 0xFF) << (8 + 24 * j))
            b_bitmap |= (math.floor(entry[1][2] * 0xFF) << (8 + 24 * j))

            r_bitmap |= (math.floor(entry[1][0] * 0xFF) << (24 * j))
            g_bitmap |= (math.floor(entry[1][1] * 0xFF) << (24 * j))
            b_bitmap |= (math.floor(entry[1][2] * 0xFF) << (24 * j))
        code += f"segmentDataArray[{i}].r = 0x{hex(r_bitmap).upper()[2:]};\n"
        code += f"segmentDataArray[{i}].g = 0x{hex(g_bitmap).upper()[2:]};\n"
        code += f"segmentDataArray[{i}].g = 0x{hex(b_bitmap).upper()[2:]};\n"

    if is_valid:
        valid_colormap_count += 1
        solidity_source += code

solidity_source = f"IColormapRegistry.SegmentData[] memory segmentDataArray = new IColormapRegistry.SegmentData[]({valid_colormap_count});\n"\
    + solidity_source\
    + f"\ncolormapRegistry.batchRegister(segmentDataArray);"

print(solidity_source)