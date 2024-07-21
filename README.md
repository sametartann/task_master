# TaskMaster

TaskMaster is a mobile application built with Flutter to help you manage your tasks efficiently. This app allows you to create, edit, and delete tasks, as well as categorize them based on their status.

## Features

- Create new tasks with a title and description.
- View a list of all tasks.
- Edit task details.
- Delete tasks with a confirmation dialog.
- Categorize tasks based on their status (New Task, Processing, Completed).

## Screenshots

![1](https://github.com/user-attachments/assets/1a6be911-9a18-4205-a2c1-d7a4b5bef867)

![2](https://github.com/user-attachments/assets/f15050c0-c291-45ca-a049-9cebff09ea75)

![3](https://github.com/user-attachments/assets/67891bcc-dd5b-4dad-82f5-83d4dd1b5764)

![4](https://github.com/user-attachments/assets/f38fd058-7437-4292-9d5d-e51ab2d7cf3b)

![5](https://github.com/user-attachments/assets/576e221a-f8a3-4bad-bc7e-789133c157e7)

![6](https://github.com/user-attachments/assets/6b39e284-d833-47b5-b053-7869a1fe6caa)

![7](https://github.com/user-attachments/assets/b418f9fa-ee13-4866-aa61-5c46cb34497a)


## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/sametartann/task_master.git
    cd task_master
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Run the app:**

    ```bash
    flutter run
    ```

## Database

TaskMaster uses Sqflite for local storage. The database schema consists of a single table called `tasks` with the following fields:

- `id`: INTEGER PRIMARY KEY
- `title`: TEXT
- `description`: TEXT
- `taskStatus`: INTEGER
- `creationDateTime`: TEXT
- `processingStartDateTime`: TEXT
- `completedDateTime`: TEXT

## Code Overview

### Main Screens

- **HomeScreen:** Displays the list of tasks and provides navigation to create new tasks or view task details.
- **TaskDetailScreen:** Shows the details of a selected task and allows editing the task.
- **TaskEditScreen:** Provides a form to edit the task details.
- **TaskCreationScreen:** Provides a form to create a new task.

### Models

- **Task:** Represents a task with properties such as `id`, `title`, `description`, `taskStatus`, `creationDateTime`, `processingStartDateTime`, and `completedDateTime`.

### Database Helper

- **DbHelper:** Manages database creation, initialization, and CRUD operations.

## Usage

1. **Create a Task:**
    - Click on the "Create First Task" button if no tasks are available or use the floating action button.
    - Fill in the task title and description, then save.

2. **View Task Details:**
    - Tap on any task from the list to view its details.

3. **Edit a Task:**
    - In the task detail view, click on the edit icon, update the details, and save.

4. **Delete a Task:**
    - Swipe left or right on a task to delete it with a confirmation dialog.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or improvements, feel free to open an issue or create a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a pull request
