import GgrMemoPresenter
import GgrMemoDomain
import GgrMemoInfra

final class RepositoryResolverImpl: RepositoryResolver {
  func provideMemoRepository() -> MemoRepository {
    MemoRepositoryImpl()
  }
}
