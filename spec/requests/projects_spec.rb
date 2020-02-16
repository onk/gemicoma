RSpec.describe "Projects", type: :request do
  let(:app) { Gemicoma }
  let(:send_request) { send(http_method, path, request_body, env).status }

  describe "POST /projects" do
    before {
      params[:url] =  "https://github.com/user_or_org/repo_name/"
      params[:path] = "/"
    }

    it {
      is_expected.to eq 302

      project = Project.last
      expect(project.site).to eq "github.com"
      expect(project.full_name).to eq "user_or_org/repo_name"
      expect(project.path).to eq ""
    }
  end
end
