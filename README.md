# Odyssey Argos Bluetooth API

This repository contains reverse-engineered documentation for the bluetooth API of the [Odyssey Argos](https://www.odysseyespresso.com/) espresso machine.

The information here was retrieved using the Odyssey IOS app, decompiling the hermes bytecode using [hbctool](https://github.com/bongtrop/hbctool).

## Service

Service UUID:`6a521c59-55b5-4384-85c0-6534e63fb09e`

The name of the device will be `ARGOS`, which can be filtered by to retrieve the peripheral. There is no connection phase, the argos is always emitting the necessary characteristics, but only a single reader can be connected at once

### Characteristics

| Characteristic      | Description                               | Details                                |
| ------------------- | ----------------------------------------- | -------------------------------------- |
| Set Point Temp      | Current "Brew Set Temp"                   | [link](/doc/set-point-temp.md)         |
| Boiler Current Temp | Current boiler temperature                | [link](/doc/boiler-current-temp.md)    |
| Boiler Target Temp  | Target boiler temperature                 | [link](/doc/boiler-target-temp.md)     |
| Grouphead Temp      | Current grouphead temperature             | [link](/doc/grouphead-current-temp.md) |
| Fluid Level         | Whether the boiler needs water            | [link](/doc/fluid-level.md)            |
| Metadata            | Metadata about the current device options | [link](/doc/metadata.md)               |

There are 2 characteristics that I am still unsure about. PRs are gladly welcome

- `6A521C67-55B5-4384-85C0-6534E63FB09E`
  - Methods: `Read`, `Notify`
  - Raw bytes (8)
  - Seems to change with temperature or pressure changes. Value goes from ~100 to ~1300

- `6A521C64-55B5-4384-85C0-6534E63FB09E`
  - Methods: `Write`, `Notify`
  - The only write characteristic, unsure of what it does
  - Could have something to do with "Unlocked Features"? (modifiable via app? `Reset Unlocked Features`)

## Example App

The example app can be used to test the bluetooth api and display data from a running argos espresso machine

```
swift ./example/example.swift
```
