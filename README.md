# Odyssey Argos Bluetooth API

## Temperature Service

Service UUID:`6a521c59-55b5-4384-85c0-6534e63fb09e`

The name of the device will be `ARGOS`, which can be filtered by to retrieve the peripheral. There is no connection phase, the argos is always emitting the necessary characteristics 

### Characteristic UUIDs

| Characteristic | UUID                                   | Description                                 |
| -------------- | -------------------------------------- | ------------------------------------------- |
| Set Point      | `6a521c60-55b5-4384-85c0-6534e63fb09e` | Target temperature set point (notify)       |
| Boiler Current | `6a521c61-55b5-4384-85c0-6534e63fb09e` | Current boiler temperature (notify)         |
| Boiler Target  | `6a521c66-55b5-4384-85c0-6534e63fb09e` | Target boiler temperature (notify)          |

## Example App

The example app can be used to test the bluetooth api and display data from a running argos espresso machine

```
swift ./example/example.swift
```