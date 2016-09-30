namespace :master_data do
  namespace :load do
    desc '銀行データの作成と更新'
    task banks_and_branches: :environment do
      banks = YAML.load_file("#{ Rails.root }/submodules/zengin-code/data/banks.yml")
      branch_dir = Dir.glob("#{ Rails.root }/submodules/zengin-code/data/branches/*.yml")

      puts '== MasterBank and MasterBankBranch data import start'
      ActiveRecord::Base.transaction do
        MasterBank.delete_all

        master_banks = banks.each_with_object([]) do |(_, val), ary|
          ary << MasterBank.new(code: val['code'], name: val['name'], name_kana: val['kana'])
        end

        MasterBank.import master_banks
        puts "- master_banks imported!! count: #{ MasterBank.count }"

        branch_dir.each do |branches_yml|
          branches = YAML.load_file(branches_yml) # 各fileが読み込まれる
          bank_code = File.basename(branches_yml, '.*') # master_bank_codeをファイル名から取得

          branches.each do |_, val|
            branch = MasterBankBranch.find_or_initialize_by(master_bank_code: bank_code, code: val['code'])
            branch.assign_attributes(name: val['name'], name_kana: val['kana'])
            branch.save!
          end
          puts "- master_bank_branches imported! bank_code: #{ bank_code }, count: #{ branches.size }"
        end
      end
      puts '== Imported MasterBanks and MasterBankBranches'
    end
  end
end
