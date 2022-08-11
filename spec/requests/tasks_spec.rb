# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :request, user: :engineer do
  describe "GET /tasks" do
    it "returns http success" do
      get tasks_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /tasks/:id" do
    subject { get task_path(create(:task)) }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    context "when task does not exist" do
      subject { get task_path(id: :id) }

      it "returns http not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /tasks/new" do
    it "returns http success" do
      get new_task_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /tasks" do
    subject { post tasks_path, params: params }

    let(:params) { { task: attributes_for(:task) } }

    it "returns http success" do
      subject
      expect(response).to redirect_to tasks_path
    end

    it "creates the task" do
      expect { subject }.to change { Task.count }.by(1)
    end

    context "when an owner is set" do
      let(:owner) { create(:user) }

      before do
        params[:task].merge!(owner: { email: owner.email })
      end

      it "returns http success" do
        subject
        expect(response).to redirect_to tasks_path
      end

      it "creates the task" do
        expect { subject }.to change { Task.count }.by(1)
      end

      it "has an owner" do
        subject
        expect(Task.last.owner).to eq owner
      end
    end

    context "when bad params present" do
      it "returns http bad request" do
        params[:task].delete(:title)
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET /tasks/edit" do
    it "returns http success" do
      get edit_task_path(create(:task))
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT /task/:id" do
    subject { put task_path(task), params: params }

    let(:task) { create(:task) }
    let(:params) { { task: { title: "new title" } } }

    it "returns http success" do
      subject
      expect(response).to redirect_to task_path(task)
    end

    it "updates the task" do
      expect { subject }.to(change { task.reload.title })
    end

    context "when an owner is set" do
      let(:owner) { create(:user) }
      let(:params) { { task: { owner: { email: owner.email } } } }

      let(:task) { create(:task) }

      it "returns http success" do
        subject
        expect(response).to redirect_to task_path(task)
      end

      it "updates the task owner" do
        expect { subject }.to(change { task.reload.owner })
      end
    end

    context "when bad params present" do
      it "returns http bad request" do
        params[:task][:title] = nil
        subject
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "DELETE /tasks/:id" do
    subject { delete task_path(task) }

    let!(:task) { create(:task) }

    it "redirects to index" do
      subject
      expect(response).to redirect_to tasks_path
    end

    it "destroys the task" do
      expect { subject }.to change { Task.count }.by(-1)
    end

    context "when task does not exist" do
      subject { delete task_path(id: :id) }

      it "returns http not found" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end