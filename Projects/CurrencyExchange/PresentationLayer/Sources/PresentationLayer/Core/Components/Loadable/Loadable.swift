enum Loadable<T> {

    case initial(placeholder: T)
    case loaded(T)
    case empty
    case error

}
