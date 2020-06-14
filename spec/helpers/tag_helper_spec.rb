RSpec.describe Gemicoma::TagHelper do
  include Gemicoma::TagHelper
  def settings
    double(public_folder: File.expand_path("../../public", __dir__))
  end

  describe "#l" do
    subject { l(obj) }
    context "When obj is nil" do
      let(:obj) { nil }
      it { should eq "" }
    end
    context "When obj is Time" do
      let(:obj) { Time.zone.parse("2020-02-20 18:38:23") }
      it { should eq "2020/02/20 18:38:23" }
    end
  end

  describe "#advisory_tag" do
    before {
      @advisory = Bundler::Audit::Advisory.new(
        nil,                   # path
        "CVE-2020-XXXX",       # id
        "http://example.com/", # url
        "Some String",         # title
        nil,                   # date
        nil,                   # description
        nil,                   # cvss_v2
        nil,                   # cvss_v3
        "2020-XXXX",           # cve
      )
    }
    subject { advisory_tag(@advisory) }
    it {
      should eq <<~HTML.chomp
      <a href="http://example.com/" data-toggle="tooltip" title="CVE-2020-XXXX: Some String"><svg class="octicon octicon-alert" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path fill-rule="evenodd" d="M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 000 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 00.01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"></path></svg></a>
      HTML
    }
  end

  describe "#span" do
    subject { span(klass: "foo") }
    it { should eq %(<span class="foo"></span>) }
  end

  describe "#status_tag" do
    subject { status_tag(status) }

    context "When status is OUTDATED" do
      let(:status) { ProjectGemVersion::Status::OUTDATED }
      it {
        should eq <<~TAG.chomp
          <span class="circle gray"></span><span class="circle gray"></span><span class="circle red"></span>
        TAG
      }
    end
    context "When status is BEHIND" do
      let(:status) { ProjectGemVersion::Status::BEHIND }
      it {
        should eq <<~TAG.chomp
          <span class="circle gray"></span><span class="circle yellow"></span><span class="circle gray"></span>
        TAG
      }
    end
    context "When status is LATEST" do
      let(:status) { ProjectGemVersion::Status::LATEST }
      it {
        should eq <<~TAG.chomp
          <span class="circle green"></span><span class="circle gray"></span><span class="circle gray"></span>
        TAG
      }
    end
  end

  describe "#site_image_tag" do
    subject { site_image_tag(site) }

    context "When site is github.com" do
      let(:site) { "github.com" }
      it { should eq %(<img src="/github.com.png" width="32" height="32">) }
    end

    context "When site is ghe.example.com" do
      let(:site) { "ghe.example.com" }
      it { should eq "ghe.example.com" }
    end
  end
end
