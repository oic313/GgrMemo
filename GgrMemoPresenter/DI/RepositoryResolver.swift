import GgrMemoDomain

public protocol RepositoryResolver {
    func provideMemoRepository() -> MemoRepository
    func provideTagRepository() -> TagRepository
}

extension RepositoryResolver {
    func resolveMemoUseCase() -> MemoUseCase {
        let memoRepository = resolveMemoRepository()
        return MemoUseCase(repository: memoRepository)
    }
    
    func resolveMemoRepository() -> MemoRepository {
        provideMemoRepository()
    }
}

extension RepositoryResolver {
    func resolveTagUseCase() -> TagUseCase {
        let tagRepository = resolveTagRepository()
        let memoRepository = resolveMemoRepository()
        return TagUseCase(tagRepository: tagRepository, memoRepository: memoRepository)
    }
    
    func resolveTagRepository() -> TagRepository {
        provideTagRepository()
    }
}
