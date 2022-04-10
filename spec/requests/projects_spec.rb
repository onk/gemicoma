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

  describe "GET /projects/:id" do
    context "when project exists" do
      let(:id) { @project.id }
      before {
        @project = Project.create!(site: "github.com", full_name: "foo/bar")
      }
      it { is_expected.to eq 200 }
    end

    context "when project not exists" do
      let(:id) { 99999999 }
      it { is_expected.to eq 404 }
    end
  end

  describe "POST /projects/:id/sync" do
    let(:id) { @project.id }
    before {
      @project = Project.create!(site: "github.com", full_name: "foo/bar")
    }

    it {
      is_expected.to eq 302
      # have_enqueued
      expect(ApplicationJob.queue_adapter.enqueued_jobs.count).to eq 1
    }
  end
end
