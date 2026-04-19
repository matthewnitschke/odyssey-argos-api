# Metadata

Current metadata about the machine

* UUID: `6A521C65-55B5-4384-85C0-6534E63FB09E`
* Methods: `READ`, `NOTIFY`
* Data Format
  * Type: `UTF8`

## Example Data

JSON is UTF8 Encoded

```jsonc
{
  "hw_major": 1,             // hardware version
  "fw_major": 1,             // firmware major version
  "fw_minor": 7,             // firmware minor version
  "fw_hotfix": 5,            // firmware hotfix version
  "auto_refill": false,      // whether or not autofill functionality is enabled
  "setpoint_offset": -2,     // set point software calibration
  "boiler_offset": 3,        // boiler calibration
  "classic_mode": false,     // whether or not classic mode is enabled
  "nickname": "Argos xxxx",  // the name of the machine
  "debug_led": false         // ? unsure what this is
}
```

