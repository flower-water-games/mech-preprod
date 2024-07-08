# Mech Jam Project

[![.github/workflows/main.yml](https://github.com/flower-water-games/mech-preprod/actions/workflows/main.yml/badge.svg)](https://github.com/flower-water-games/mech-preprod/actions/workflows/main.yml)

## Installation and Use

1. Clone the repository
2. Open the project in Godot 4.2.2-stable
3. If you don't have the Export templates, Download, and be sure the Web export preset is shown (export_presets.cfg is committed to the repo but feel free to change the path)
4. Checkout a new branch with a descriptive name `feature/feature-name`
5. Bump the minor version number in ProjectSettings (`0.0.1` -> `0.0.2`)
6. Test and build (Export) your game locally via RemoteDebug Feature in Godot (test it in a browser)
7. Create a Pull Request into the desired branch (typically `main`), and merge it in with an optional reviewer
8. Check to verify that your build successfully ran. Be sure to stop any workflow that takes longer than normal.
9. Verify the build on itch.io works as expected.

## Devops

the repo has the `main` branch protected for direct pushes, pull requests (PRs) are required.  there are also 3 branches that trigger a gh actions pipeline build:

`main` - builds the game, and pushes to itch.io
`workflows` - builds the game
`playtest` - builds the game, could be used to add a staging link


## best practices for github collab

PRs should be made into one of those 3 branches on the repo, but it's only required for `main`

= Test the build locally, in a browser, (via Remote Debug) before delivering a PR to main to not use minutes building something that hasn't been verified to build

cm notes
- also, its important to verify the build built successfully in the actual gh actions pipeline
- my rec is if the game takes any longer than the average last 5 runs, (1-2 minutes so far) cancel it, it's likely going to hang forever. 
- there are some build errors that unfortunately could run infinitely. there are some basic limits to not overspend our monthly gh actions minutes limit, but just good practice. build times can thankfully be pretty short (thank god for godot)

![a1](/documentation/images/actions/a1.png)
![a2](/documentation/images/actions/a2.png)
![a3](/documentation/images/actions/a3.png)
![a4](/documentation/images/actions/a4.png)
![a5](/documentation/images/actions/a5.png)

## Current Game Overview
This is an "infinite-style" 2D sidescroller where players shoot enemies in progressively difficult waves of enemies. The game ends when the player completes all waves (win) or dies (lose). 

NOTE, To quickly add a boss, you can add a final "wave" with one large enemy.

## Detailed Documentation

For more details, please read: [technical documentation](/documentation/README.md)


## Core Systems
- **ScrollManager**: Controls game duration and difficulty progression based on a curve.
- **GameManager**: Manages game state and enemy spawning based on current difficulty.
- **EnemyFactory**: Handles enemy creation and types.
- **Player**: Consists of movement, shooting, and health components.

## Key Scripts
### Enemy
- `enemy.gd`: Base enemy behavior (extends CharacterBody2D).
- `enemy_factory.gd`: Enemy spawning and type management.

### Managers
- `game_manager.gd`: Overall game flow and state control.
- `scroll_manager.gd`: Difficulty progression and game time management.

### Player
- `bullet.gd`: Bullet physics and collision (extends CharacterBody2D).
- `gun.gd`: Player weapon mechanics.
- `health.gd`: Health system for player and enemies.
- `movement.gd`: Player movement and physics (extends CharacterBody2D).

## Important Scenes
![directory structure](/documentation/images/mainfiles.png)
- `/scenes/GameScene/MainGameScene.tscn`: Main game scene.
- `/Components`: Reusable scene components (bullets, enemies, health).
- `/EnemyVariants`: Custom enemy types inheriting from `enemy_2d.tscn`.

## Global Systems (Autoloads)
- **AppConfig**: Persistent player data.
- **SceneLoader**: Handles scene transitions.
- **ProjectMusicController**: Manages background music.
- **ProjectUISoundsController**: Handles UI sound effects.

## MainGameScene Structure
- **Services**: Game managers and menu controllers.
- **World2D**: In-game entities.
- **CanvasLayer**: UI elements.
![current scene tree](/documentation/images/image.png) 

## Additional Resources
- Uses [Maaack's game template](https://github.com/Maaack/Godot-Game-Template) for scene loading, transitions, menus, and score saving.

