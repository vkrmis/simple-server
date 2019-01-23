def common_names
  {
    'english' =>
      { 'female'      => %w[Anjali Divya Ishita Priya Priyanka Riya Shreya Tanvi Tanya Vani].take(3).take(3),
        'male'        => %w[Abhishek Aditya Amit Ankit Deepak Mahesh Rahul Rohit Shyam Yash].take(3),
        'transgender' => %w[Bharathi Madhu Bharathi Manabi Anjum Vani Riya Shreya Kiran Amit].take(3),
        'last_name'   => %w[Lamba Bahl Sodhi Sardana Puri Chhabra Khanna Malhotra Mehra Garewal Dhillon].take(3)
      },

    'punjabi' =>
      {
        'female'      => %w[ਅੰਜਲੀ ਦਿਵਿਆ ਇਸ਼ਿਤਾ ਪ੍ਰਿਆ ਪ੍ਰਿਯੰਕਾ ਰਿਯਾ ਸ਼੍ਰੇਯਾ ਟਾਂਵੀ ਤੰਯਾ ਵਨੀ].take(3),
        'male'        => %w[ਅਭਿਸ਼ੇਕ ਆਦਿਤਿਆ ਅਮਿਤ ਅੰਕਿਤ ਦੀਪਕ ਮਹੇਸ਼ ਰਾਹੁਲ ਰੋਹਿਤ ਸ਼ਿਆਮ ਯਸ਼ ].take(3),
        'transgender' => %w[ਭਰਾਠੀ ਮਧੂ ਮਾਨਬੀ ਅੰਜੁਮ ਵਨੀ ਰਿਯਾ ਸ਼੍ਰੇਯਾ ਕਿਰਨ ਅਮਿਤ].take(3),
        'last_name'   => %w[ਲੰਬਾ ਬਹਿਲ ਸੋਢੀ ਸਰਦਾਨਾ ਪੂਰੀ ਛਾਬੜਾ ਖੰਨਾ ਮਲਹੋਤਰਾ ਮੇਹਰ ਗਰੇਵਾਲ ਢਿੱਲੋਂ].take(3)
      }
  }
end

def common_addresses
  {
    'bathinda' => {
      'english' => {
        street_name:       ['Bhagat singh colony', 'Gandhi Basti', 'NFL Colony', 'Farid Nagari'],
        village_or_colony: %w[Bathinda Bhagwangarh Dannewala Nandgarh Nathana],
      },
      'punjabi' => {
        street_name:       ['ਭਗਤ ਸਿੰਘ ਕਾਲੋਨੀ', 'ਗਾਂਧੀ ਬਸਤੀ', 'ਨਫ਼ਲ ਕਾਲੋਨੀ', 'ਫਰੀਦ ਨਗਰੀ'],
        village_or_colony: %w[ਬਠਿੰਡਾ ਭਗਵੰਗੜ੍ਹ ਡੰਨਵਾਲਾ ਨੰਦਗੜ੍ਹ ਨਥਾਣਾ],
      }
    },
    'mansa'    => {
      'english' => {
        street_name:       ['Bathinda Road', 'Bus Stand Rd', 'Hirke Road', 'Makhewala Jhanduke Road'],
        village_or_colony: ['Bhikhi', 'Budhlada', 'Hirke', 'Jhanduke', 'Mansa', 'Bareta', 'Bhaini Bagha', 'Sadulgarh', 'Sardulewala']
      },
      'punjabi' => {
        street_name:       ['ਬਠਿੰਡਾ ਰੋਡ', 'ਬੱਸ ਸਟੈਂਡ ਰੱਦ', 'ਹੀਰਕੇ ਰੋਡ', 'ਮਖੇਵਾਲਾ ਝੰਡੂਕੇ ਰੋਡ'],
        village_or_colony: ['ਭੀਖੀ', 'ਬੁਢਲਾਡਾ', 'ਹੀਰਕੇ', 'ਝੰਡੂਕੇ', 'ਮਾਨਸਾ', 'ਬਰੇਟਾ', 'ਭੈਣੀ ਬਾਘਾ', 'ਸਾਦੁਲਗੜ੍ਹ', 'ਸਰਦੁਲੇਵਾਲਾ']
      }
    }
  }
end

def random_date(from = 0.0, to = Time.now)
  Time.at(from + rand * (to.to_f - from.to_f))
end

def generate_phone_number
  digits       = (0..9).to_a
  phone_number = ''
  10.times do
    phone_number += digits.sample.to_s
  end
  phone_number
end

def create_random_patient_phone_number(patient_id)
  patient_phone_number = {
    id:                SecureRandom.uuid,
    number:            generate_phone_number,
    phone_type:        PatientPhoneNumber::PHONE_TYPE.sample,
    active:            true,
    patient_id:        patient_id,
    device_created_at: Time.now,
    device_updated_at: Time.now
  }
  PatientPhoneNumber.create(patient_phone_number)
end

def create_random_address(district, language)
  addresses = common_addresses[district][language]
  address   = {
    id:                SecureRandom.uuid,
    street_address:    "# #{rand(100)}, #{addresses[:street_name].sample}",
    village_or_colony: addresses[:village_or_colony].sample,
    district:          district,
    state:             language == 'punjabi' ? 'ਪੰਜਾਬ' : 'Punjab',
    country:           language == 'punjabi' ? 'ਇੰਡੀਆ' : 'India',
    pin:               district == 'bathinda' ? "1510#{rand(100)}" : "1515#{rand(100)}",
    device_created_at: Time.now,
    device_updated_at: Time.now
  }
  Address.create(address)
end

def create_random_patient(address_id, language)
  has_age   = [true, false].sample
  gender    = Patient::GENDERS.sample
  full_name = "#{common_names[language][gender].sample} #{common_names[language]['last_name'].sample}"
  patient   = {
    id:                SecureRandom.uuid,
    gender:            gender,
    full_name:         full_name,
    status:            'active',
    age:               has_age ? rand(18..100) : nil,
    age_updated_at:    has_age ? Time.now : nil,
    address_id:        address_id,
    date_of_birth:     !has_age ? random_date : nil,
    device_created_at: Time.now,
    device_updated_at: Time.now,
    test_data:         true
  }

  Patient.create(patient)
end

def dev_organizations
  [
    {
      name: "IHMI",
      facility_groups: [
        {
          name: "Bathinda and Mansa",
          facilities: [
            { name: "CHC Buccho", district: "Bathinda", state: "Punjab" },
            { name: "CHC Meheraj", district: "Bathinda", state: "Punjab" },
            { name: "District Hospital Bathinda", district: "Bathinda", state: "Punjab" },
            { name: "PHC Joga", district: "Mansa", state: "Punjab" }
          ]
        },
        {
          name: "Gurdaspur",
          facilities: [
            { name: "CHC Kalanaur", district: "Gurdaspur", state: "Punjab" },
            { name: "PHC Bhumbli", district: "Gurdaspur", state: "Punjab" },
            { name: "SDH Batala", district: "Gurdaspur", state: "Punjab" }
          ]
        },
      ]
    },
    {
      name: "PATH",
      facility_groups: [
        {
          name: "Amir Singh Facility Group",
          facilities: [
            { name: "Amir Singh", district: "Mumbai", state: "Maharashtra" }
          ]
        },
        {
          name: "Dr. Anwar Facility Group",
          facilities: [
            { name: "Dr. Anwar", district: "Mumbai", state: "Maharashtra" }
          ]
        },
        {
          name: "Sangam Clinic Facility Group",
          facilities: [
            { name: "Sangam Clinic", district: "Mumbai", state: "Maharashtra" }
          ]
        }
      ]
    }
  ]
end

def rand_date
  (180.days.ago.to_date..Date.today).reject { |day| day.sunday? }.sample
end

def rand_systolic
  rand(90..200)
end

def rand_diastolic
  rand(60..110)
end

def rand_patient(facility)
  facility.registered_patients.limit(1).order("RANDOM()").last
end

namespace :generate do
  desc "Generate fake data for development"
  task dev_facilities: :environment do
    Admin.destroy_all
    Organization.destroy_all
    FacilityGroup.destroy_all
    Facility.destroy_all
    User.destroy_all

    Admin.create(email: "admin@simple.org", password: "password", role: :owner)

    protocol = Protocol.first

    dev_organizations.each do |dev_organization|
      organization = FactoryBot.create(:organization, name: dev_organization[:name])

      dev_organization[:facility_groups].each do |dev_facility_group|
        facility_group = FactoryBot.create(
          :facility_group,
          organization: organization,
          name: dev_facility_group[:name],
          protocol: protocol
        )

        dev_facility_group[:facilities].each do |dev_facility|
          facility = FactoryBot.create(
            :facility,
            facility_group: facility_group,
            name: dev_facility[:name],
            district: dev_facility[:district],
            state: dev_facility[:state]
          )

          rand(1..3).times do
            FactoryBot.create(
              :user,
              facility: facility
            )
          end
        end
      end
    end
  end

  desc "Generate fake patients for development"
  task dev_patients: :environment do
    PatientPhoneNumber.destroy_all
    Patient.destroy_all
    Address.destroy_all

    Facility.all.each do |facility|
      facility.users.each do |user|
        rand(10..25).times do
          patient_date = rand_date

          FactoryBot.create(
            :patient,
            device_created_at: patient_date,
            device_updated_at: patient_date,
            registration_facility: facility,
            registration_user: user
          )
        end
      end
    end
  end

  desc "Generate blood pressures for development"
  task dev_blood_pressures: :environment do
    BloodPressure.destroy_all

    (180.days.ago.to_date..Date.today).reject { |day| day.sunday? }.each do |bp_date|
      Facility.all.each do |facility|
        facility.users.each do |user|
          # Skip random users
          next if rand(1..4) == 1

          rand(0..10).times do
            rand_patient(facility).blood_pressures.create!(
              id: SecureRandom.uuid,
              facility: facility,
              user: user,
              systolic: rand_systolic,
              diastolic: rand_diastolic,
              device_created_at: bp_date,
              device_updated_at: bp_date
            )
          end
        end
      end
    end
  end

  desc 'Generate test patients for user tests'
  # Example: rake "generate:random_patients_for_user_tests[20]"
  task :random_patients_for_user_tests, [:number_of_patients_to_generate] => :environment do |_t, args|
    max_patient_phone_numbers      = 1
    number_of_patients_to_generate = args.number_of_patients_to_generate.to_i

    number_of_patients_to_generate.times do
      district = common_addresses.keys.sample
      language = common_addresses[district].keys.sample
      address  = create_random_address(district, language)
      patient  = create_random_patient(address.id, language)
      rand(1..max_patient_phone_numbers).times do
        create_random_patient_phone_number(patient.id)
      end
    end
  end

  task :patients_for_user_tests => :environment do
    test_patient_data = [
      { full_name: "Govind Lamba", age: 57, language: 'english' },
      { full_name: "Govind Lamba", age: 41, language: 'english' },
      { full_name: "Govind Lamba", age: 79, language: 'english' },
      { full_name: "Govind Lamba", age: 33, language: 'english' },
      { full_name: "Govind Lamba", age: 30, language: 'english' },
      { full_name: "Govind Bahl", age: 51, language: 'english' },
      { full_name: "Govind Bahl", age: 48, language: 'english' },
      { full_name: "Govind Bahl", age: 21, language: 'english' },
      { full_name: "Govind Bahl", age: 54, language: 'english' },
      { full_name: "Govind Bahl", age: 77, language: 'english' },
      { full_name: "Govind Sodhi", age: 89, language: 'english' },
      { full_name: "Govind Sodhi", age: 36, language: 'english' },
      { full_name: "Govind Sodhi", age: 82, language: 'english' },
      { full_name: "Govind Sodhi", age: 64, language: 'english' },
      { full_name: "Govind Sodhi", age: 79, language: 'english' },
      { full_name: "Harjeet Lamba", age: 54, language: 'english' },
      { full_name: "Harjeet Lamba", age: 67, language: 'english' },
      { full_name: "Harjeet Lamba", age: 40, language: 'english' },
      { full_name: "Harjeet Lamba", age: 29, language: 'english' },
      { full_name: "Harjeet Lamba", age: 67, language: 'english' },
      { full_name: "Harjeet Bahl", age: 66, language: 'english' },
      { full_name: "Harjeet Bahl", age: 22, language: 'english' },
      { full_name: "Harjeet Bahl", age: 37, language: 'english' },
      { full_name: "Harjeet Bahl", age: 52, language: 'english' },
      { full_name: "Harjeet Bahl", age: 31, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 30, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 44, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 68, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 51, language: 'english' },
      { full_name: "Harjeet Sodhi", age: 55, language: 'english' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 83, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 52, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 69, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 24, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਲੰਬਾ", age: 44, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 84, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 76, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 85, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 39, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਬਹਿਲ", age: 81, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 22, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 90, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 44, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 22, language: 'punjabi' },
      { full_name: "ਗੋਵਿੰਦ ਸੋਢੀ", age: 23, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 38, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 30, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 43, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 42, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਲੰਬਾ", age: 90, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 56, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 34, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 31, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 69, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਬਹਿਲ", age: 57, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 30, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 81, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 29, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 66, language: 'punjabi' },
      { full_name: "ਹਰਜੀਤ ਸੋਢੀ", age: 57, language: 'punjabi' }
    ]

    test_patient_data.each do |patient_data|
      patient = Patient.create(
        id:                SecureRandom.uuid,
        full_name:         patient_data[:full_name],
        age:               patient_data[:age],
        gender:            'male',
        status:            'active',
        age_updated_at:    Time.now,
        address_id:        create_random_address('bathinda', patient_data[:language]).id,
        date_of_birth:     nil,
        device_created_at: Time.now,
        device_updated_at: Time.now,
        test_data:         true)
      create_random_patient_phone_number(patient.id)
    end
  end
end
