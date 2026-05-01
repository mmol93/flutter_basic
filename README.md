# flutter_basic

This project is a Flutter + Riverpod architecture playground.

The app is organized by screen so you can quickly understand what each screen demonstrates and why it exists.
As more Flutter examples are added, each screen is documented with its purpose, state flow, and design decisions.

## Screen Index

### 1) Entry Screen

- **File**: `lib/ui/entry_page.dart`
- **Route role**: App starting point (`home` in `lib/main.dart`)

#### What this screen does

- Shows a list of available demo screens.
- Navigates to the selected screen (currently `TodoPage`).

#### Why this screen exists

- Keeps `main.dart` minimal (bootstrap only).
- Makes the project scalable as more screens are added.
- Provides a single discoverable place to explore examples.

### 2) Todo Screen

- **File**: `lib/ui/todo_page.dart`
- **Demo focus**: Riverpod state management patterns in a practical UI

#### What this screen does

- Loads an initial todo list asynchronously.
- Shows loading, error, and data UI states.
- Filters todos by `All`, `Completed`, and `Pending`.
- Toggles completion per item.
- Adds a new todo from a dialog input.

#### Why this screen is implemented this way

The screen is split by responsibility so UI remains simple and logic stays testable/reusable.

##### a) ViewModel for synchronous UI state

- `lib/viewmodel/todo/todo_filter_viewmodel.dart`
- Uses `NotifierProvider` style (`TodoFilterViewModel`) for lightweight mutable filter state.
- Uses `TodoFilter` enum (`all`, `completed`, `pending`) to avoid string-based state bugs.

##### b) ViewModel for asynchronous domain state

- `lib/viewmodel/todo/todos_viewmodel.dart`
- Uses `AsyncNotifierProvider` style (`TodosViewModel`) for async loading and commands (`addTodo`, `toggle`).
- Centralizes business logic and exposes `AsyncValue` to the UI.

##### c) Derived provider for computed results

- `lib/viewmodel/todo/filtered_todos_viewmodel.dart`
- Uses function-style derived provider (`filteredTodosProvider`) for computed state.
- Combines todos + current filter into a computed list through a pure filtering function.

##### d) Partial UI updates for performance

- `lib/ui/todo_page.dart`
- Uses `Consumer` and `select` to watch only the needed slice of state (for example, a single checkbox state).
- Reduces unnecessary rebuilds when only part of the list changes.

## App Flow (by screen)

1. App starts with `ProviderScope` in `lib/main.dart`.
2. `EntryPage` lists available demos.
3. User selects `Todo Page`.
4. `TodoPage` renders UI from provider state and dispatches user actions back to ViewModels.

