protocol_data = {
  name:           'Punjab Hypertension Protocol',
  follow_up_days: 30
}

protocol_drugs_data = [
  { name: 'Amlodipine', dosage: '5 mg' },
  { name: 'Amlodipine', dosage: '10 mg' },
  { name: 'Telmisartan', dosage: '40 mg' },
  { name: 'Telmisartan', dosage: '80 mg' },
  { name: 'Chlorthalidone', dosage: '12.5 mg' },
  { name: 'Chlorthalidonex', dosage: '25 mg' },
  { name: 'Losartan', dosage: '50 mg' },
  { name: 'Losartan', dosage: '100 mg' },
  { name: 'Atenolol', dosage: '25 mg' },
  { name: 'Atenolol', dosage: '50 mg' },
  { name: 'Hydrochlorothiazide', dosage: '12.5 mg' },
  { name: 'Hydrochlorothiazide', dosage: '25 mg' },
  { name: 'Aspirin', dosage: '75 mg' },
  { name: 'Aspirin', dosage: '150 mg' },
  { name: 'Enalapril', dosage: '5 mg' },
  { name: 'Enalapril', dosage: '10 mg' },
]

protocol = Protocol.find_or_create_by(protocol_data)
protocol_drugs_data.each do |drug_data|
  ProtocolDrug.find_or_create_by(drug_data.merge(protocol_id: protocol.id))
end
