# Паттерн Observer - "Наблюдатель"

## Назначение

Определяет зависимость типа "один ко многим" между объектами таким образом, что при изменении состояния одного объекта все зависящие от него оповещаются об этом.

Похожее есть в C# и называется events, в Qt и называется Signals/Slots.

## Использование

в классе определяем событие

```Swift
// AuthManager
let usernameChangedEvent  = Subject<String>()
```

в классах слушателях определяем метод

```Swift
// UserInfoViewController
func onUsernameChanged(newUsername: String) {
  ...
}
```

и подписываемся на события

```Swift
// UserInfoViewController
AuthManager.usernameChangedEvent.attach(self, UserInfoViewController.onUsernameChanged)
```

после этого рассылаем события

```Swift
// AuthManager
usernameChangedEvent.notify("Vasya")
```

Более подробные примеры использования [тут](/ObserverTests/ObserverTests.swift).
