RSpec.describe "Projects", type: :request do
  let(:app) { Gemicoma }

  describe "POST /projects" do
    it {
      post "/projects", { url:  "https://github.com/user_or_org/repo_name/", path: "/" }
      expect(last_response.status).to eq 302

      project = Project.last
      expect(project.site).to eq "github.com"
      expect(project.full_name).to eq "user_or_org/repo_name"
      expect(project.path).to eq ""
    }
  end
end
