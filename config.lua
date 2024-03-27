Config = {}
Config.Locales = {
    Order = 'Order',
    Tray = 'Receive the tray',
    TrayTwo = 'To put the trays down, hold down the E key',
    NoMoney = 'You are missing: $'
}


Config.Restaurants = {
    ['pablito_ghetto_plucker'] = {
        coords = vec3(167.8676, -1469.21, 35.14285),
        ped_model = 'mp_m_shopkeep_01',
        ped_spawn = vector4(146.3674, -1477.686, 29.35708, 46.05428),
        ped_route = {vector4(144.6223, -1476.174, 29.35708, 50.63741),vector4(138.7664, -1471.562, 29.35707, 50.42436), vector4(140.5021, -1469.395, 29.35707, 317.5753), vector4(139.4314, -1468.124, 29.3571, 42.4259)},
        ped_route2 = {vector4(143.9037, -1465.721, 29.35707, 237.1546),vector4(147.5528, -1468.87, 29.35707, 232.1567)},
        ped_route3 = {vector4(143.9037, -1465.721, 29.35707, 160.1546),vector4(139.4314, -1468.124, 29.3571, 42.4259)},
        take = vector4(140.5735, -1466.814, 29.95707, 316.7247),
        items = {
            {name='burger', label="Burger", price = 10},
            {name='water', label="Water", price = 5}
        }
    },

    ['pablito_restauracja'] = {
        coords = vec3(139.3624, -1058.949, 22.96025),
        ped_model = 'mp_m_shopkeep_01',
        ped_spawn = vector4(139.3624, -1058.949, 22.96025, 69.58369),
        ped_route = {vector4(137.6449, -1058.231, 22.96025, 67.40278),vector4(134.0975, -1056.85, 22.96024, 71.65182), vector4(130.7535, -1056.346, 22.96022, 45.29485), vector4(131.6964, -1055.196, 22.96022, 346.8894)},
        ped_route2 = {vector4(132.0757, -1056.306, 22.96023, 252.8605), vector4(137.3788, -1057.941, 22.96023, 252.3907), vector4(143.395, -1055.825, 22.96023, 78.96611)},
        ped_route3 = {vector4(143.7869, -1058.155, 22.96023, 157.6815), vector4(141.8315, -1059.215, 22.96023, 67.66502), vector4(133.7843, -1056.706, 22.96023, 71.47466), vector4(131.3182, -1056.169, 22.96023, 343.3743), vector4(131.6964, -1055.196, 22.96022, 346.8894) },
        take = vector4(132.7822, -1054.693, 23.8569, 139.9991),
        items = {
            {name='fish', label="Fish", price = 11},
            {name='cola', label="eCola", price = 7}
        }
    },

}
