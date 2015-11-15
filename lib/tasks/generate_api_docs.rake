task generate_api_docs: :environment do
  `rspec spec --tag apidoc -f ApiBlueprint --out spec/apispec.md`
  `aglio -i spec/apispec.md -o spec/apispec.html`
end
