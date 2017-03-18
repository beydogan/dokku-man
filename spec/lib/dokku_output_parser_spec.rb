require "rails_helper"

describe DokkuOutputParser do
  let :outputs do
    {
    "postgres:list" => "NAME    VERSION         STATUS   EXPOSED PORTS  LINKS\napi     postgres:9.6.1  running  -              api \nhello_world  postgres:9.6.1  running  -              -\napp1     postgres:9.6.1  running  -              -\napp2    postgres:9.6.1  running  -              -",
    "ps:scale" => "-----> Scaling for api\n-----> proctype           qty                                                                          \n-----> --------           ---                                                                          \n-----> web                1                                                                            \n-----> worker             1                                                                            "
    }
  end

  it "parses postgres:list output" do
    result = DokkuOutputParser.new("postgres:list", outputs["postgres:list"]).parse
    output_hash = [
      {name: "api", version: "postgres:9.6.1", status: "running", links: "api"},
      {name: "hello_world", version: "postgres:9.6.1", status: "running", links: "-"},
      {name: "app1", version: "postgres:9.6.1", status: "running", links: "-"},
      {name: "app2", version: "postgres:9.6.1", status: "running", links: "-"},
    ]
    expect(result).to eq output_hash
  end

  it "parses ps:scale output" do
    result = DokkuOutputParser.new("ps:scale", outputs["ps:scale"]).parse
    output_hash = [
      {proc_type: "web", quantity: "1"},
      {proc_type: "worker", quantity: "1"},
    ]
    expect(result).to eq output_hash
  end
end
