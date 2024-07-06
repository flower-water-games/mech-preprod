# mech jam project

## basic overview of high level systems

## Scripts Overview

### Enemy
- `enemy.gd`:`CharacterBody2D` Defines basic enemy behavior and attributes.
- `enemy_factory.gd`: Handles enemy creation, spawning, and specifies types.

### Managers
- `game_manager.gd`: Oversees game state, score, and overall game flow.
- `scroll_manager.gd`: based on the defined time of the game, and a tweakable difficulty curve, returns back a 0-1 difficulty score(or raw progress) usable by the game manager to determine which enemies to spawn

### Player
- `bullet.gd`: `CharacterBody2D` Controls bullet behavior, movement, and collision.
- `gun.gd`: Handles shooting mechanics and weapon properties (for the player).
- `health.gd`: Manages player health and damage system. Also used by `Enemy`
- `movement.gd`: `CharacterBody2D` Controls player movement and physics, also stores a reference to health


<!-- ## scene tree

![current scene tree](/documentation/images/image.png) -->

## additional libraries

<!-- - bulletuphell library for bullet hell mechanics -->
- [maack's game template for scene loading, transitions, menus, saving player score](/addons/maaacks_game_template/docs/NewProject.md)
