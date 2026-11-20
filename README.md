# Calm Reflective Water for Morrowind

A water shader modification for OpenMW RTX and an optional water-lily plugin for Tamriel Rebuilt. Calmer ripples carry reflections across the surface. In the shallows, daylight draws caustic lines across the bed, with bright glints where the lines meet. Overcast weather softens the pattern away. A dark mustard tannin tint fades gradually into deeper water.

The lily beds mix green, bronze and aging yellow pads. Branching veins, mottled interiors and rust-colored margins are painted into twelve diffuse textures and embedded in the animated meshes.

![The twelve lily pad diffuse textures](lily-textures.jpg)

## Water installation

Use [OpenMW RTX rtx-v0.4.5](https://github.com/xorza/openmw-rtx/releases/tag/rtx-v0.4.5). Make a full copy of that installation’s resources directory. Overlay this project's resources directory onto the copy, merging the rtx/shaders directories. Launch OpenMW RTX with the absolute path of the completed copy:

```sh
openmw --resources "/path/to/copied/resources"
```

To revert the water, launch with your original resources directory.

## Optional lily beds

The supplied ESP declares Morrowind.esm, Bloodmoon.esm, Tamriel_Data.esm, TR_Mainland.esm and Anthology Solstheim.esm as masters. With those installed and enabled, add the following to the active openmw.cfg, substituting the absolute path where you installed this project. Load the lily plugin after its masters.

```ini
data="/path/to/Monet Water Lilies"
content=Monet Water Lilies.esp
```

## Source and credits

The water shaders build on [xorza/openmw-rtx](https://github.com/xorza/openmw-rtx/tree/69ca79e6ab710a04052836c981fcc544f53da9c0). The source patch is relative to that exact revision. From a checkout of that revision, run `git apply /path/to/source/water.patch` and follow the upstream RTX shader build. The upstream license is included in [source/LICENSE](source/LICENSE).

Developed by Francisco in collaboration with Codex. The lily artwork was created with ImageGen and adapted for the meshes. The yellowing and reddish-brown leaf spots draw on observations documented in the [RHS waterlily growing guide](https://www.rhs.org.uk/plants/waterlilies/growing-guide).
