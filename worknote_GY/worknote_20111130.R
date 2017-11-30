library(RMySQL)

con1<- dbConnect(MySQL(), user = 'reader',password = 'jyjf@read_db*2017', host = 'rm-2ze9xw4d2j00rgvv2o.mysql.rds.aliyuncs.com', dbname='cash_loan_dev')

dbSendQuery(con1,'SET NAMES GBK')

app_version <- dbGetQuery(conn = con1, statement = "show full columns from app_version;")
bank_card_message <- dbGetQuery(conn = con1, statement = "show full columns from bank_card_message;")
black_list <- dbGetQuery(conn = con1, statement = "show full columns from black_list;")
cl_a_contract <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_contract;")
cl_a_loan_agreemen_info <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_loan_agreemen_info;")
cl_a_loan_cost <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_loan_cost;")
cl_a_loan_order <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_loan_order;")
cl_a_loan_order_queue <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_loan_order_queue;")
cl_a_repay_plan <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_repay_plan;")
cl_a_repayment_record <- dbGetQuery(conn = con1, statement = "show full columns from cl_a_repayment_record;")
cl_t_back_comments <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_back_comments;")
cl_t_bankcard <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_bankcard;")
cl_t_banklist <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_banklist;")
cl_t_idcard_info <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_idcard_info;")
cl_t_interface_record <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_interface_record;")
cl_t_into_contacts <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_into_contacts;")
cl_t_into_info <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_into_info;")
cl_t_into_status <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_into_status;")
cl_t_into_userbase <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_into_userbase;")
cl_t_login_access <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_login_access;")
cl_t_login_record <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_login_record;")
cl_t_m_address <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_m_address;")
cl_t_m_book <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_m_book;")
cl_t_m_info <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_m_info;")
cl_t_m_message <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_m_message;")
cl_t_m_record <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_m_record;")
cl_t_maxno <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_maxno;")
cl_t_message <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_message;")
cl_t_product <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_product;")
cl_t_sm_code <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_sm_code;")
cl_t_sm_code_check <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_sm_code_check;")
cl_t_sm_record <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_sm_record;")
cl_t_sm_record_copy <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_sm_record_copy;")
cl_t_sys_msg <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_sys_msg;")
cl_t_test_user <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_test_user;")
cl_t_user <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_user;")
cl_t_user_token <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_user_token;")
cl_t_verify_info <- dbGetQuery(conn = con1, statement = "show full columns from cl_t_verify_info;")
ext_jxl_invoke <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_invoke;")
ext_jxl_raw_basic <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_raw_basic;")
ext_jxl_raw_calls <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_raw_calls;")
ext_jxl_raw_nets <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_raw_nets;")
ext_jxl_raw_smses <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_raw_smses;")
ext_jxl_raw_transactions <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_raw_transactions;")
ext_jxl_report_cell_behavior <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_report_cell_behavior;")
ext_jxl_report_contact_list <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_report_contact_list;")
ext_jxl_report_contact_region <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_report_contact_region;")
ext_jxl_token_record <- dbGetQuery(conn = con1, statement = "show full columns from ext_jxl_token_record;")
ext_nc_bank_login_type <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_bank_login_type;")
ext_nc_banklist <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_banklist;")
ext_nc_banklogin_name_des <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_banklogin_name_des;")
ext_nc_banklogin_password_des <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_banklogin_password_des;")
ext_nc_bill_info <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_bill_info;")
ext_nc_bill_installment <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_bill_installment;")
ext_nc_bill_month <- dbGetQuery(conn = con1, statement = "show full columns from ext_nc_bill_month;")
ext_sh_pbcc <- dbGetQuery(conn = con1, statement = "show full columns from ext_sh_pbcc;")
job_log <- dbGetQuery(conn = con1, statement = "show full columns from job_log;")
overdue <- dbGetQuery(conn = con1, statement = "show full columns from overdue;")
overdue_order <- dbGetQuery(conn = con1, statement = "show full columns from overdue_order;")
sms_auth_code <- dbGetQuery(conn = con1, statement = "show full columns from sms_auth_code;")
sms_history <- dbGetQuery(conn = con1, statement = "show full columns from sms_history;")
sys_area <- dbGetQuery(conn = con1, statement = "show full columns from sys_area;")
sys_dict <- dbGetQuery(conn = con1, statement = "show full columns from sys_dict;")
sys_dict_detail <- dbGetQuery(conn = con1, statement = "show full columns from sys_dict_detail;")
sys_dictionary <- dbGetQuery(conn = con1, statement = "show full columns from sys_dictionary;")
sys_menu <- dbGetQuery(conn = con1, statement = "show full columns from sys_menu;")
sys_resource <- dbGetQuery(conn = con1, statement = "show full columns from sys_resource;")
sys_role <- dbGetQuery(conn = con1, statement = "show full columns from sys_role;")
sys_role_user <- dbGetQuery(conn = con1, statement = "show full columns from sys_role_user;")
sys_user <- dbGetQuery(conn = con1, statement = "show full columns from sys_user;")

all_tables_columns<-rbind(app_version,
                          bank_card_message,
                          black_list,
                          cl_a_contract,
                          cl_a_loan_agreemen_info,
                          cl_a_loan_cost,
                          cl_a_loan_order,
                          cl_a_loan_order_queue,
                          cl_a_repay_plan,
                          cl_a_repayment_record,
                          cl_t_back_comments,
                          cl_t_bankcard,
                          cl_t_banklist,
                          cl_t_idcard_info,
                          cl_t_interface_record,
                          cl_t_into_contacts,
                          cl_t_into_info,
                          cl_t_into_status,
                          cl_t_into_userbase,
                          cl_t_login_access,
                          cl_t_login_record,
                          cl_t_m_address,
                          cl_t_m_book,
                          cl_t_m_info,
                          cl_t_m_message,
                          cl_t_m_record,
                          cl_t_maxno,
                          cl_t_message,
                          cl_t_product,
                          cl_t_sm_code,
                          cl_t_sm_code_check,
                          cl_t_sm_record,
                          cl_t_sm_record_copy,
                          cl_t_sys_msg,
                          cl_t_test_user,
                          cl_t_user,
                          cl_t_user_token,
                          cl_t_verify_info,
                          ext_jxl_invoke,
                          ext_jxl_raw_basic,
                          ext_jxl_raw_calls,
                          ext_jxl_raw_nets,
                          ext_jxl_raw_smses,
                          ext_jxl_raw_transactions,
                          ext_jxl_report_cell_behavior,
                          ext_jxl_report_contact_list,
                          ext_jxl_report_contact_region,
                          ext_jxl_token_record,
                          ext_nc_bank_login_type,
                          ext_nc_banklist,
                          ext_nc_banklogin_name_des,
                          ext_nc_banklogin_password_des,
                          ext_nc_bill_info,
                          ext_nc_bill_installment,
                          ext_nc_bill_month,
                          ext_sh_pbcc,
                          job_log,
                          overdue,
                          overdue_order,
                          sms_auth_code,
                          sms_history,
                          sys_area,
                          sys_dict,
                          sys_dict_detail,
                          sys_dictionary,
                          sys_menu,
                          sys_resource,
                          sys_role,
                          sys_role_user,
                          sys_user)

View(all_tables_columns)


