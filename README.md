# Mech Jam Project

[![.github/workflows/main.yml](https://github.com/flower-water-games/mech-preprod/actions/workflows/main.yml/badge.svg)](https://github.com/flower-water-games/mech-preprod/actions/workflows/main.yml)

## Current Status Overview
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

