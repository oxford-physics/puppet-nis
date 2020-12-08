require 'spec_helper'
describe 'nis' do
  context 'with default values for all parameters' do
    it { should contain_class('nis') }
  end
end
