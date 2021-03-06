# frozen_string_literal: true

require_relative '../../../lib/persistence/relations/evolutions'
require_relative '../../../db/connection'
require_relative '../../../lib/repositories/evolution_repo'

RSpec.describe Persistence::Relations::Evolutions do
  describe 'associations' do
    describe '.evolves_from' do
      let!(:pokemon_evolves_from) { TestingFactory[:pokemon] }
      let!(:pokemon_evolves_into) { TestingFactory[:pokemon] }
      let!(:evolution) do
        TestingFactory[
          :evolution,
          evolves_from_id: pokemon_evolves_from.id,
          evolves_into_id: pokemon_evolves_into.id
        ]
      end
      let(:evolution_repo) do
        Repositories::EvolutionRepo.new(
          Db::Connection.registered_container
        )
      end

      subject do
        evolution_repo.evolutions.combine(:evolves_from).first
      end

      it 'relates to a pokemon record' do
        expect(subject.evolves_from.id).to eq(pokemon_evolves_from.id)
      end
    end

    describe '.evolves_into' do
      let!(:pokemon_evolves_from) { TestingFactory[:pokemon] }
      let!(:pokemon_evolves_into) { TestingFactory[:pokemon] }
      let!(:evolution) do
        TestingFactory[
          :evolution,
          evolves_from_id: pokemon_evolves_from.id,
          evolves_into_id: pokemon_evolves_into.id
        ]
      end
      let(:evolution_repo) do
        Repositories::EvolutionRepo.new(
          Db::Connection.registered_container
        )
      end

      subject do
        evolution_repo.evolutions.combine(:evolves_into).first
      end

      it 'relates to a pokemon record' do
        expect(subject.evolves_into.id).to eq(pokemon_evolves_into.id)
      end
    end

    describe '#product' do
      let(:evolution_repo) do
        Repositories::EvolutionRepo.new(
          Db::Connection.registered_container
        )
      end

      subject do
        evolution_repo.evolutions.combine(:product).by_pk(evolution.id).one!
      end

      context 'if product_id is nil' do
        let!(:evolution) do
          TestingFactory[
            :evolution,
            product_id: nil
          ]
        end

        it 'is nil' do
          expect(subject.product).to be_nil
        end
      end

      context 'if product_id is present' do
        let!(:product) { TestingFactory[:product] }
        let!(:evolution) do
          TestingFactory[
            :evolution,
            product_id: product.id
          ]
        end

        it 'belongs_to a product' do
          expect(subject.product.id).to eq(product.id)
        end
      end
    end
  end

  describe 'auto-struct' do
    let!(:evolution) do
      TestingFactory[:evolution]
    end
    let(:evolution_repo) do
      Repositories::EvolutionRepo.new(
        Db::Connection.registered_container
      )
    end

    subject do
      evolution_repo.evolutions.by_pk(evolution.id).one!
    end

    it 'auto-structs as a Entities::Evolution' do
      expect(subject).to be_a(Entities::Evolution)
    end
  end
end
