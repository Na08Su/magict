emails = [
  'yuichi.ai@luxiar.com',
  'yusuke.matsuda@luxiar.com',
  'yuta.tokuda@luxiar.com',
  'natsuki.sugawara@luxiar.com',
]
user_attributes = emails.map { |email| { email: email, password: 'password' } }
User.seed_once(:email, user_attributes)

# FIXME: dumpデータに依存してるので、いづれ作り直したい
Employee.seed_once(:user_id,
  { user_id: User.find_by(email: emails[0]).id, firstname: '祐一', lastname: '阿井', company_id: 1781, code: rand(1..9999), technical_flag: true,  sales_flag: true,  foreman_flag: true  },
  { user_id: User.find_by(email: emails[1]).id, firstname: '祐輔', lastname: '松田', company_id: 1781, code: rand(1..9999), technical_flag: true,  sales_flag: false, foreman_flag: true  },
  { user_id: User.find_by(email: emails[2]).id, firstname: '裕太', lastname: '徳田', company_id: 1781, code: rand(1..9999), technical_flag: false, sales_flag: true,  foreman_flag: true  },
  { user_id: User.find_by(email: emails[3]).id, firstname: '夏樹', lastname: '菅原', company_id: 1781, code: rand(1..9999), technical_flag: false, sales_flag: true,  foreman_flag: false },
)
