
enum Result<T, U>  where U: Error {
    case success(payload: T)
    case failure(U?)
}
