import GgrMemoDomain

public protocol RepositoryResolver {
  func provideMemoRepository() -> MemoRepository
}

extension RepositoryResolver {
  func resolveMemoUseCase() -> MemoUseCase {
    let MemoRepository = resolveMemoRepository()
    return MemoUseCase(repository: MemoRepository)
  }
  
  func resolveMemoRepository() -> MemoRepository {
    provideMemoRepository()
  }
}
