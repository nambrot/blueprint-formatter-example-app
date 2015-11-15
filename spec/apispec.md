Run options: include {:apidoc=>true}
# Group API V1
# Medications [/patients/:id/medications]
## Retrieve all Medications [GET]

This endpoint allows you to get all medications of a patient

+ Request retrievs the patients medications

        {}
        
        Location: ./spec/controllers/medications_controller_spec.rb:22
        Source code:
        
            it 'retrievs the patients medications' do
              retrieve_medications
              expect(JSON.parse(response.body).length).to eql 1
              expect(response).to have_http_status(:ok)
            end

+ Response 200 (application/json)

        [{"id":1,"name":"existing-name","patient_id":1,"created_at":"2015-11-16T04:48:53.791Z","updated_at":"2015-11-16T04:48:53.791Z"}]

+ Request with an invalid patient_id fails

        {}
        
        Location: ./spec/controllers/medications_controller_spec.rb:31
        Source code:
        
              it 'fails' do
                retrieve_medications
                expect(response).to have_http_status(:not_found)
              end

+ Response 404 (application/json)

        {}

## Change a given medication [PATCH]

This endpoint allows you to change the name of a medication 

+ Request with an invalid name fails to update medication

        {"medication":{"name":null}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:48
        Source code:
        
              it 'fails to update medication' do
                expect { update_medication }.not_to change { medication.reload.name }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["can't be blank"]}}

+ Request with a valid name succeeds in updating a medication

        {"medication":{"name":"valid name"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:55
        Source code:
        
              it 'succeeds in updating a medication' do
                expect { update_medication }.to change { medication.reload.name }
                expect(response).to have_http_status(:no_content)
              end

+ Response 204 (application/json)

        

+ Request with a valid name that is already taken by another medication fails to update medication

        {"medication":{"name":"valid name"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:48
        Source code:
        
              it 'fails to update medication' do
                expect { update_medication }.not_to change { medication.reload.name }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["has already been taken"]}}

+ Request with a valid name when the patient is pre-surgery and the med name is Aspirin fails to update medication

        {"medication":{"name":"Aspirin"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:48
        Source code:
        
              it 'fails to update medication' do
                expect { update_medication }.not_to change { medication.reload.name }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["cannot be Aspirin when patient is pre-surgery"]}}

+ Request with a valid name when the patient is pre-surgery and the med name is Tylenol succeeds in updating a medication

        {"medication":{"name":"Tylenol"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:55
        Source code:
        
              it 'succeeds in updating a medication' do
                expect { update_medication }.to change { medication.reload.name }
                expect(response).to have_http_status(:no_content)
              end

+ Response 204 (application/json)

        

+ Request with invalid patient_id fails

        {"medication":{"name":null}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:97
        Source code:
        
              it 'fails' do
                update_medication
                expect(response).to have_http_status(:not_found)
              end

+ Response 404 (application/json)

        {}

## Creating a new medication for a patient [POST]

This endpoint allows you to create a medication for a given patient when passing valid parameters. Some medications are not allowed for some patients.

+ Request with an invalid name fails to create a medication

        {"medication":{"name":null}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:113
        Source code:
        
              it 'fails to create a medication' do
                expect { create_medication }.not_to change { Medication.count }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["can't be blank"]}}

+ Request with a valid name succeeds in creating a medication

        {"medication":{"name":"valid name"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:120
        Source code:
        
              it 'succeeds in creating a medication' do
                expect { create_medication }.to change { Medication.count }
                expect(response).to have_http_status(:created)
              end

+ Response 201 (application/json)

        {"id":1,"name":"valid name","patient_id":1,"created_at":"2015-11-16T04:48:53.942Z","updated_at":"2015-11-16T04:48:53.942Z"}

+ Request with a valid name that is already taken by another medication fails to create a medication

        {"medication":{"name":"valid name"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:113
        Source code:
        
              it 'fails to create a medication' do
                expect { create_medication }.not_to change { Medication.count }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["has already been taken"]}}

+ Request with a valid name when the patient is pre-surgery and the med name is Aspirin fails to create a medication

        {"medication":{"name":"Aspirin"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:113
        Source code:
        
              it 'fails to create a medication' do
                expect { create_medication }.not_to change { Medication.count }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["cannot be Aspirin when patient is pre-surgery"]}}

+ Request with a valid name when the patient is pre-surgery and the med name is Tylenol succeeds in creating a medication

        {"medication":{"name":"Tylenol"}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:120
        Source code:
        
              it 'succeeds in creating a medication' do
                expect { create_medication }.to change { Medication.count }
                expect(response).to have_http_status(:created)
              end

+ Response 201 (application/json)

        {"id":1,"name":"Tylenol","patient_id":1,"created_at":"2015-11-16T04:48:53.976Z","updated_at":"2015-11-16T04:48:53.976Z"}

+ Request with invalid patient_id fails

        {"medication":{"name":null}}
        
        Location: ./spec/controllers/medications_controller_spec.rb:163
        Source code:
        
              it 'fails' do
                create_medication
                expect(response).to have_http_status(:not_found)
              end

+ Response 404 (application/json)

        {}

# Patients [/patients]
## Creating a patient [POST]

This endpoint allows you to create a Patient

+ Request with an invalid name fails to create a patient

        {"patient":{"name":null}}
        
        Location: ./spec/controllers/patients_controller_spec.rb:19
        Source code:
        
              it 'fails to create a patient' do
                expect { create_patient }.not_to change { Patient.count }
                expect(response).to have_http_status(:unprocessable_entity)
              end

+ Response 422 (application/json)

        {"errors":{"name":["can't be blank"]}}

+ Request with a valid name succeeds in creating a patient

        {"patient":{"name":"valid name"}}
        
        Location: ./spec/controllers/patients_controller_spec.rb:28
        Source code:
        
              it 'succeeds in creating a patient' do
                expect { create_patient }.to change { Patient.count }
                expect(response).to have_http_status(:created)
              end

+ Response 201 (application/json)

        {"id":1,"name":"valid name","status":"healthy","created_at":"2015-11-16T04:48:53.993Z","updated_at":"2015-11-16T04:48:53.993Z"}

+ Request with a valid name that is already taken by another patient fails to create a patient

        {"patient":{"name":"valid name"}}
        
        Location: ./spec/controllers/patients_controller_spec.rb:36
        Source code:
        
                it 'fails to create a patient' do
                  expect { create_patient }.not_to change { Patient.count }
                  expect(response).to have_http_status(:unprocessable_entity)
                end

+ Response 422 (application/json)

        {"errors":{"name":["has already been taken"]}}


Finished in 0.26441 seconds (files took 1.39 seconds to load)
17 examples, 0 failures

