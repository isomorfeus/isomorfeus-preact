require 'spec_helper'

RSpec.describe 'Props declaration and validation' do
  before do
    @doc = visit('/')
  end

  it 'sets default value' do
    result = on_server do
      class PropWhatever
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: String, default: 'a value'
        prop :test_b, type: String
      end

      PropWhatever.validated_props(test_b: 'bill@gates.com')
    end
    expect(result).to eq({test_a: 'a value', test_b: 'bill@gates.com'})

    result = @doc.evaluate_ruby do
      class PropWhatever
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: String, default: 'a value'
        prop :test_b, type: String
      end

      PropWhatever.validated_props(test_b: 'bill@gates.com').to_n
    end
    expect(result).to eq({'test_a' => 'a value', 'test_b' => 'bill@gates.com'})
  end

  it 'works even though a ensure_block did not return anything' do
    result = on_server do
      class PropWhatever
        extend LucidPropDeclaration::Mixin

        prop :test_a, ensure_block: proc { |v| nil }
        prop :test_b, ensure_block: ->(v) { nil }
      end

      PropWhatever.validated_props(test_a: 23, test_b: 24)
    end
    expect(result).to eq({test_a: nil, test_b: nil})

    result = @doc.evaluate_ruby do
      class PropWhatever
        extend LucidPropDeclaration::Mixin

        prop :test_a, ensure_block: proc { |v| nil if v == 0 }
        prop :test_b, ensure_block: ->(v) { nil if v == 0 }
      end

      PropWhatever.validated_props(test_a: 23, test_b: 24).to_n
    end
    expect(result).to eq({'test_a' => nil, 'test_b' => nil})
  end

  it 'can verify email addresses' do
    result = on_server do
      class PropWhateverEmail
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: :email
      end

      a = PropWhateverEmail.validated_props(test_a: 'bill@gates.com')
      b = PropWhateverEmail.valid_prop?(:test_a, 'bill')
      [a, b]
    end
    expect(result).to eq([{test_a: 'bill@gates.com'}, false])

    result = @doc.evaluate_ruby do
      class PropWhateverEmail
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: :email
      end

      a = PropWhateverEmail.validated_props(test_a: 'bill@gates.com').to_n
      b = PropWhateverEmail.valid_prop?(:test_a, 'bill')
      [a, b]
    end
    expect(result).to eq([{'test_a' => 'bill@gates.com'}, false])
  end

  it 'can verify uris' do
    result = on_server do
      class PropWhateverUri
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: :uri
      end

      a = PropWhateverUri.validated_props(test_a: 'http://www.test.com')
      b = PropWhateverUri.valid_prop?(:test_a, 'test')
      [a, b]
    end
    expect(result).to eq([{test_a: 'http://www.test.com'}, false])

    result = @doc.evaluate_ruby do
      class PropWhateverUri
        extend LucidPropDeclaration::Mixin

        prop :test_a, type: :uri
      end

      a = PropWhateverUri.validated_props(test_a: 'http://www.test.com').to_n
      b = PropWhateverUri.valid_prop?(:test_a, 'test')
      [a, b]
    end
    expect(result).to eq([{'test_a' => 'http://www.test.com'}, false])
  end
end
