# 💀 FiveM Death Script (with ox_lib)

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Status](https://img.shields.io/badge/status-active-success)
[![Join our Discord](https://img.shields.io/discord/1336789892180738162?style=flat-square&logo=discord)](https://discord.gg/pHsTfwAXbF)
[![Support me on Patreon](https://img.shields.io/badge/Patreon-FF424D?style=flat&logo=patreon&logoColor=white)](https://www.patreon.com/c/smocdevelopment/membership)

A standalone, immersive death system for FiveM using `ox_lib`. This script replaces the default respawn behavior with a custom NUI interface, realistic delays, and optional emergency alerts — giving players full control over what happens after they die.

---

## 📦 Features

- 🩸 Custom **bloody screen overlay** and centered "You are dead" message.
- ⏳ Configurable **revive (E)** and **respawn (R)** countdowns.
- 🧍 Players stay dead — **no automatic respawn**.
- 📢 Press **G** to alert emergency services with **road name**.
- 🔔 Countdown **notifications using ox_lib**.
- 🔒 Fully **disable all controls** while dead, except E / R / G.
- ⚙️ Simple configuration for enabling/disabling revive/respawn and setting timers.

---

## 🔧 Configuration

You can change settings directly in `client.lua`:

```lua
local config = {
    enableRespawn = true,      -- Allow respawning at hospital
    enableRevive = true,       -- Allow reviving in place
    respawnDelay = 15,         -- Seconds before respawn is available
    reviveDelay = 10,          -- Seconds before revive is available
}
