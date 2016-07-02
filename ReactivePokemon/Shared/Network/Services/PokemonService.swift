import Moya
import ReactiveCocoa
import Result

final class PokemonService {
    private let provider: ProviderType

    init(provider: ProviderType = Provider.sharedInstance) {
        self.provider = provider
    }

    func getPokemonByID(id: String) -> SignalProducer<Pokemon?, NoError> {
        return provider.request(.Pokemon(id: id))
            .map(Pokemon.decode)
            .map { $0.value }
            .flatMapError { _ in return SignalProducer<Pokemon?, NoError>.empty }
    }

    func getPokemonMainTypeByPokemonID(id: String) -> SignalProducer<Type?, NoError> {
        return getPokemonByID(id)
            .map { pokemon in
                pokemon?.types.first?.type.id
            }.flatMap(.Latest) {(id: String?) -> SignalProducer<Type?, NoError> in
                guard let id = id else { return SignalProducer.empty }
                return self.getTypeByID(id)
        }
    }

    func getPokemonTypesByPokemonID(id: String) -> SignalProducer<[Type], NoError> {
        return getPokemonByID(id)
            .map { pokemon in
                pokemon?.types.map{$0.type.id} ?? []
            }.flatMap(.Latest) { (ids: [String]) -> SignalProducer<[Type?], NoError> in
                let signals = ids.map { self.getTypeByID($0) }
                return SignalProducer(values: signals).flatten(.Merge).collect()
        }.map{$0.flatMap{$0}}
    }

    func getTheUltimatePokemonTeam(trainerID: String, pokemonID: String) -> SignalProducer<PokemonTeam?, NoError> {
        return getPokemonByID(pokemonID)
            .zipWith(getTrainerByID(trainerID))
            .map { pokemon, trainerName in
                guard let pokemon = pokemon, trainerName = trainerName else { assertionFailure("Couldn't find the pokemon and trainer for this ultimate team"); return nil }
                return PokemonTeam(trainerName: trainerName, pokemon: pokemon)
        }
    }

    func getPokemonByIDAndFightTeamRocket(id: String) -> SignalProducer<Bool, NoError> {
        return getPokemonByID(id)
            .map { pokemon in
                guard let pokemon = pokemon else { return }
                print("Consulting with Professor Oak about my new \(pokemon.name)")
            }.then(fightTeamRocket)
    }

    private func getTrainerByID(id: String) -> SignalProducer<String?, NoError> {
        return SignalProducer { observer, disposable in
            observer.sendNext("Ash Ketchum")
            observer.sendCompleted()
        }
    }

    struct PokemonTeam {
        let trainerName: String
        let pokemon: Pokemon
    }

    private var fightTeamRocket: SignalProducer<Bool, NoError> {
        return SignalProducer<Bool, NoError> { observer, disposable in
            print("Fighting Team Rocket")
            observer.sendNext(true)
            print("Defeated Team Rocket!")
            observer.sendCompleted()
        }
    }

    private func getTypeByID(id: String) -> SignalProducer<Type?, NoError> {
        return provider.request(.Pokemon(id: id))
            .map(Type.decode)
            .map { $0.value }
            .flatMapError { _ in return SignalProducer<Type?, NoError>.empty }
    }
}
