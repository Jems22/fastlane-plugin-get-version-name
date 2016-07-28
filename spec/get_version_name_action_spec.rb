describe Fastlane::Actions::GetVersionNameAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The get_version_name plugin is working!")

      Fastlane::Actions::GetVersionNameAction.run(nil)
    end
  end
end
