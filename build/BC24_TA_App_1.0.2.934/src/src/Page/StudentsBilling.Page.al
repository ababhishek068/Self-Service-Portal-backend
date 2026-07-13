page 50194 "Students Billing"
{
    Caption = 'Student Card';
    PageType = Card;
    PromotedActionCategories = 'Process,Navigate,Action,Approve,Request Approval,Customer';
    SourceTable = Customer;
    UsageCategory = Documents;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                    Visible = NoFieldVisible;
                    TableRelation = "Registration Form"."Serial No";
                    trigger OnValidate()
                    var
                        RegForm: record "Registration Form";
                    begin
                        if RegForm.get(Rec."No.") then begin
                            Rec.Name := RegForm."Full Names";
                            Rec.Gender := RegForm.Gender;
                            Rec."Customer Type" := Rec."Customer Type"::Student;
                            Rec."Customer Posting Group" := 'STUDENT';
                            //Rec.Region := RegForm.Region;
                            Rec.Address := RegForm."Nearest Town";
                            Rec."ID No" := RegForm."ID Number";
                            Rec.Disabled := RegForm."Is Disable";
                            Rec.Image := Regform."Applicant Photo";
                            Rec.modify;
                        end;
                    end;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies an alternate name that you can use to search for a customer.';
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Date Registered"; Rec."Date Registered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Registered field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';
                }

                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID No field.';
                }
                field("KNEC No"; Rec."KNEC No")
                {
                    ApplicationArea = All;
                    Caption = 'External No.';
                    ToolTip = 'Specifies the value of the External No. field.';
                }

                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                    trigger OnDrillDown()
                    begin
                        Rec.OpenCustomerLedgerEntries(false);
                    end;
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies payments from the customer that are overdue per today''s date.';

                    trigger OnDrillDown()
                    begin
                        Rec.OpenCustomerLedgerEntries(true);
                    end;
                }

                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';

                    trigger OnValidate()
                    begin
                        StyleTxt := Rec.SetStyle;
                    end;
                }
                field("Customer Balance"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                }
                field("Debit Amount"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.';
                }
                field("Credit Amount"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which transactions with the customer that cannot be blocked, for example, because the customer is insolvent.';
                }

                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }

                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disabled field.';
                }
                field("Disability Details"; Rec."Disability Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disability Details field.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nationality field.';
                }
                field("Region Code"; Rec."Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Region Code field.';
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the customer card was last modified.';
                }
                group(Academics)
                {
                    Caption = 'Academics';
                    field("Enrolled Programmes"; Rec."Enrolled Programmes")
                    {

                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Enrolled Programmes field.';


                    }
                    field("Completed Units"; Rec."Completed Units")
                    {
                        Caption = 'Completed Units(Credits)';
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Completed Units(Credits) field.';

                    }
                    field("Attempted Units"; Rec."Attempted Units")
                    {
                        Caption = 'Attempted Units(Credits)';
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Attempted Units(Credits) field.';

                    }



                    field("Entry Intake"; Rec."Entry Intake")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Entry Intake field.';

                    }

                    field("Current Programme"; Rec."Current Programme")
                    {
                        ApplicationArea = All;
                        Caption = 'Programme';
                        ToolTip = 'Specifies the value of the Programme field.';
                    }




                    field("Application No."; Rec."Application No.")
                    {
                        Caption = 'Online Application Ref. No';
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Online Application Ref. No field.';
                    }
                    field("Class Code"; Rec."Class Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Class Code field.';

                    }


                }
            }
            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; Rec.Address)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field(City; Rec.City)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the customer''s city.';
                    }

                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap; ShowMapLbl)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            Rec.DisplayMap;
                        end;
                    }

                    group(ContactDetails)
                    {
                        Caption = 'Contact';
                        field("Primary Contact No."; Rec."Primary Contact No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Primary Contact Code';
                            ToolTip = 'Specifies the primary contact number for the customer.';
                        }
                        field(ContactName; Rec.Contact)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact Name';
                            Editable = ContactEditable;
                            Importance = Promoted;
                            ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';

                            trigger OnValidate()
                            begin
                                ContactOnAfterValidate;
                            end;
                        }
                        field("Phone No."; Rec."Phone No.")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the customer''s telephone number.';
                        }
                        field("Sponsor Phone"; Rec."Sponsor Phone")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the Sponsor''s telephone number.';
                        }
                        field("E-Mail"; Rec."E-Mail")
                        {
                            ApplicationArea = Basic, Suite;
                            ExtendedDatatype = EMail;
                            Importance = Promoted;
                            ToolTip = 'Specifies the customer''s email address.';
                        }
                        field("Marital Status"; Rec."Marital Status")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the value of the Marital Status field.';

                        }
                        field(Citizenship; Rec.Citizenship)
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the value of the Citizenship field.';

                        }
                        field("Sponsor Name"; Rec."Sponsor Name")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the value of the Sponsor Name field.';

                        }


                        field("Fax No."; Rec."Fax No.")
                        {
                            ApplicationArea = Advanced;
                            Importance = Additional;
                            ToolTip = 'Specifies the customer''s fax number.';
                        }
                        field("Home Page"; Rec."Home Page")
                        {
                            ApplicationArea = Basic, Suite;
                            ToolTip = 'Specifies the customer''s home page address.';
                        }
                        field("Language Code"; Rec."Language Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Importance = Additional;
                            ToolTip = 'Specifies the language to be used on printouts for this customer.';
                        }

                        field("Changed Password"; Rec."Changed Password")
                        {
                            ApplicationArea = Basic, Suite;
                            Visible = false;
                            ToolTip = 'Specifies the value of the Changed Password field.';
                        }
                    }
                    group(Welfare)
                    {
                        field(Remarks; Rec.Remarks)
                        {
                            Caption = 'Medical Remarks';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Medical Remarks field.';

                        }

                    }
                    group(Graduation)
                    {
                        field("Graduating Programme"; Rec."Graduating Programme")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Graduating Programme field.';

                        }
                        field("Completed Units Curr Prog"; Rec."Completed Units Curr Prog")
                        {
                            Caption = 'Completed Units(Prog)';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Completed Units(Prog) field.';

                        }
                        field("Required Units"; Rec."Required Units")
                        {
                            Caption = 'Required Units(Audit)';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Required Units(Audit) field.';

                        }
                        field("Programme Required Units"; Rec."Programme Required Units")
                        {
                            Caption = 'Required Units(Programme)';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Required Units(Programme) field.';

                        }
                        field("Can Graduate"; Rec."Can Graduate")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Can Graduate field.';
                        }
                        field("Graduation Date"; Rec."Graduation Date")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Graduation Date field.';
                        }
                        field("Certificate Status"; Rec."Certificate Status")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Certificate Status field.';
                        }
                        field("Certificate No."; Rec."Certificate No.")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Certificate No. field.';
                        }
                        field("Date Collected"; Rec."Date Collected")
                        {
                            caption = 'Certificate Collection Date';
                            ToolTip = 'Specifies the value of the Certificate Collection Date field.';
                        }
                    }

                }
                group(Invoicing)
                {
                    Caption = 'Invoicing';

                    group(PostingDetails)
                    {
                        Caption = 'Posting Details';
                    }
                    field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bill-to Customer';
                        Importance = Additional;
                        ToolTip = 'Specifies a different customer who will be invoiced for products that you sell to the customer in the Name field on the customer card.';
                    }
                    field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
                    }
                    field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the customer''s VAT specification to link transactions made for this customer to.';
                    }
                    field("Customer Posting Group"; Rec."Customer Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                    }
                    field("Currency Code"; Rec."Currency Code")
                    {
                        ApplicationArea = Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the default currency for the customer.';
                    }
                    field("Application Method"; Rec."Application Method")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies how to apply payments to entries for this customer.';
                    }

                    field(Password; Rec.Password)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the value of the Password field.';
                        // Visible = false;
                    }
                }


                group(Statistics)
                {
                    Caption = 'Statistics';
                    Editable = false;
                    Visible = FoundationOnly;
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field("Balance (LCY)2"; Rec."Balance (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Money Owed - Current';
                            ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                            trigger OnDrillDown()
                            begin
                                Rec.OpenCustomerLedgerEntries(false);
                            end;
                        }

                        field(TotalMoneyOwed; Rec."Balance (LCY)" + GetMoneyOwedExpected)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Money Owed - Total';
                            Style = Strong;
                            StyleExpr = TRUE;
                            ToolTip = 'Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing. The value is the sum of the values in the Money Owed - Current and Money Owed - Expected fields.';
                        }
                        field(CreditLimit; Rec."Credit Limit (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Credit Limit';
                            ToolTip = 'Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.';
                        }
                        field(CalcCreditLimitLCYExpendedPct; Rec.CalcCreditLimitLCYExpendedPct)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Usage Of Credit Limit';
                            ExtendedDatatype = Ratio;
                            Style = Attention;
                            StyleExpr = BalanceExhausted;
                            ToolTip = 'Specifies how much of the customer''s payment balance consists of credit.';
                        }
                    }
                    group(Payments)
                    {
                        Caption = 'Payments';

                        field("Payments (LCY)"; Rec."Payments (LCY)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Payments This Year';
                            ToolTip = 'Specifies the sum of payments received from the customer in the current fiscal year.';
                        }
                        field("CustomerMgt.AvgDaysToPay(""No."")"; CustomerMgt.AvgDaysToPay(Rec."No."))
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Average Collection Period (Days)';
                            DecimalPlaces = 0 : 1;
                            Importance = Additional;
                            ToolTip = 'Specifies how long the customer typically takes to pay invoices in the current fiscal year.';
                        }
                        field(DaysPaidPastDueDate; DaysPastDueDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Average Late Payments (Days)';
                            DecimalPlaces = 0 : 1;
                            Importance = Additional;
                            Style = Attention;
                            StyleExpr = AttentionToPaidDay;
                            ToolTip = 'Specifies the average number of days the customer is late with payments.';
                        }
                    }

                    part(AgedAccReceivableChart; "Aged Acc. Receivable Chart")
                    {
                        ApplicationArea = Advanced;
                        SubPageLink = "No." = FIELD("No.");
                        Visible = ShowCharts;
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control149; "Customer Picture")
            {
                Caption = 'Student Picture';
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = NOT IsOfficeAddin;
            }
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Student Attachments';
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
            }

            part("Other Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Application Attachments';
                SubPageLink = "Table ID" = CONST(70134877),
                              "No." = FIELD("Application No.");
            }



            part(Details; "Office Customer Details")
            {
                ApplicationArea = All;
                Caption = 'Details';
                SubPageLink = "No." = FIELD("No.");
                Visible = IsOfficeAddin;
            }
            part(AgedAccReceivableChart2; "Aged Acc. Receivable Chart")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = IsOfficeAddin;
            }
            part(Control39; "CRM Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
            }
            // part(Control35; "Social Listening FactBox")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "Source Type" = CONST(Customer),
            //                   "Source No." = FIELD("No.");
            //     Visible = SocialListeningVisible;
            // }
            // part(Control27; "Social Listening Setup FactBox")
            // {
            //     ApplicationArea = All;
            //     SubPageLink = "Source Type" = CONST(Customer),
            //                   "Source No." = FIELD("No.");
            //     UpdatePropagation = Both;
            //     Visible = SocialListeningSetupVisible;
            // }
            part(SalesHistSelltoFactBox; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part(SalesHistBilltoFactBox; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(CustomerStatisticsFactBox; "Customer Statistics FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part(Control1905532107; "Dimensions FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
            }
            part(Control1907829707; "Service Hist. Sell-to FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1902613707; "Service Hist. Bill-to FactBox")
            {
                ApplicationArea = Advanced;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links) { }
            systempart(Control1905767507; Notes) { }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {

                action(ApprovalEntries)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';


                }
                action(CustomerReportSelections)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Document Layouts';
                    Image = Quote;
                    ToolTip = 'Set up a layout for different types of documents such as invoices, quotes, and credit memos.';

                    trigger OnAction()
                    var
                        CustomReportSelection: Record "Custom Report Selection";
                    begin
                        CustomReportSelection.SetRange("Source Type", DATABASE::Customer);
                        CustomReportSelection.SetRange("Source No.", Rec."No.");
                        PAGE.RunModal(PAGE::"Customer Report Selections", CustomReportSelection);
                    end;
                }
            }
            group(Student)
            {
                Caption = 'Student';
                action(EnrolDet)
                {
                    ApplicationArea = All;
                    Caption = 'Enrollment Details';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Registration Card";
                    RunPageLink = "Serial No" = FIELD("No.");
                    ToolTip = 'Executes the Enrollment Details action.';
                }
                action(Registration)
                {
                    ApplicationArea = All;
                    Caption = 'Programme Registrations';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Course Registration List";
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Programme Registrations action.';
                }
                action("Student Units")
                {
                    ApplicationArea = All;
                    Caption = 'Student Units';
                    Image = BOMRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Student Units - List";
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Student Units action.';
                }


                action("Transfer Student Accounts")
                {
                    Caption = 'Transfer Student Accounts';
                    Image = TransferFunds;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    RunObject = Page "Students Transfer";
                    RunPageLink = "Student No" = FIELD("No.");
                    ToolTip = 'Executes the Transfer Student Accounts action.';
                }
                action("Catering Funds Transfer")
                {
                    Caption = 'Catering Funds Transfer';
                    Image = TransferFunds;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = all;
                    RunObject = Page "Catering Funds Transfer";
                    RunPageLink = "Student No" = FIELD("No.");
                    ToolTip = 'Executes the Catering Funds Transfer action.';
                }
                action("Student Units Audit")
                {
                    ApplicationArea = All;
                    Caption = 'Student Audit';
                    Image = BOMRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Student Units Audit";
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Student Audit action.';
                }

                action("StudentTrns")
                {
                    ApplicationArea = All;
                    Caption = 'Print Transcript';
                    Image = PrintAcknowledgement;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Print Transcript action.';
                    trigger OnAction()
                    var
                        StudAudit: Report "Student Results Slip";
                        StudAuditRec: Record "Student Units";
                    begin
                        StudAuditRec.Reset;
                        StudAuditRec.SetRange(StudAuditRec."Student No.", Rec."No.");
                        StudAuditRec.SetRange(StudAuditRec.Programme, Rec."Enrolled Programmes");
                        if StudAuditRec.Find('+') then begin
                            StudAudit.SetTableView(StudAuditRec);
                            StudAudit.Run();
                        end;
                    end;

                }
                action("StudentAudit")
                {
                    ApplicationArea = All;
                    Caption = 'Print Academic Progress Report';
                    Image = PrintAcknowledgement;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Print Academic Progress Report action.';
                    trigger OnAction()
                    var
                        StudAudit: Report "Student Audit";
                        StudAuditRec: Record "Student Units Audit";
                    begin
                        StudAuditRec.Reset;
                        StudAuditRec.SetRange(StudAuditRec."Student No.", Rec."No.");
                        if StudAuditRec.Find('+') then begin
                            StudAudit.SetTableView(StudAuditRec);
                            StudAudit.Run();
                        end;
                    end;

                }


                action("Mark As Alluminae")
                {
                    ApplicationArea = All;
                    Caption = 'Mark As Alluminae';
                    Image = Status;
                    ToolTip = 'Executes the Mark As Alluminae action.';

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to mark this students as an alluminae?', true) = true then begin
                            Rec.Status := Rec.Status::Alluminae;
                            Rec.Modify;
                        end;
                    end;
                }
                action("Student ID Card")
                {
                    ApplicationArea = All;
                    Caption = 'Student ID Card';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Student ID Card action.';

                    trigger OnAction()
                    var
                        StudID: Report "Student ID";
                    begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            StudID.SetTableView(Cust);
                        StudID.Run();

                    end;
                }
                action("Student Kin")
                {
                    ApplicationArea = All;
                    Image = CustomerContact;
                    Promoted = true;
                    RunObject = Page "Student Kin";
                    RunPageLink = "Student No" = FIELD("No.");
                    ToolTip = 'Executes the Student Kin action.';
                }



                action("Student Disciplinary Details")
                {
                    ApplicationArea = All;
                    Image = Addresses;
                    Promoted = true;
                    RunObject = Page "Student Disciplinary Details";
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Student Disciplinary Details action.';
                }

                action("Student Units Exemptions")
                {
                    ApplicationArea = All;
                    Image = Reserve;
                    Promoted = true;
                    RunObject = Page "Student Units Exemptions";
                    RunPageLink = "Student No." = FIELD("No."), Programme = field("Current Programme");
                    ToolTip = 'Executes the Student Units Exemptions action.';
                }
                action("Reset Password")
                {
                    ApplicationArea = All;
                    Image = Restore;
                    Promoted = true;
                    ToolTip = 'Executes the Reset Password action.';

                    trigger OnAction()
                    begin
                        if Confirm('Do you realy want to reset the student password?', false) then begin
                            CurrPage.Update;
                            Rec.Password := Rec."No.";
                            Rec.Modify;
                            Message('The password has been reset to ' + Rec."No.");

                        end;
                    end;
                }
                action("Enroll Biometric")
                {
                    ApplicationArea = All;
                    Caption = 'Enroll Biometric';
                    Image = Export1099;
                    ToolTip = 'Executes the Enroll Biometric action.';
                    /*
                                        trigger OnAction()
                                        var

                                            RESTWSManagement: Codeunit "REST WS Management";
                                            stringContent: DotNet StringContent;
                                            httpUtility: DotNet HttpUtility;
                                            encoding: DotNet Encoding;
                                            result: DotNet String;
                                            resultParts: DotNet Array;
                                            separator: DotNet String;
                                            HttpResponseMessage: DotNet HttpResponseMessage;
                                            JsonConvert: DotNet JsonConvert;
                                            null: DotNet Object;
                                            Window: Dialog;
                                            data: Text;
                                            statusCode: Text;
                                            statusText: Text;
                                            ReturnValue: Boolean;
                                            localData: text;
                                            UserSetup: record "User Setup";
                                            CateringSetup: Record "Catering SetUp";
                                        begin
                                            Window.OPEN('Exporting to Biometric Device...');
                                            CateringSetup.GET();
                                            CateringSetup.testfield("Biometrics API Endpoint");
                                            UserSetup.RESET;
                                            UserSetup.SETRANGE("User ID", UserId);
                                            if UserSetup.find('-') then
                                                UserSetup.TESTFIELD("IP Address");

                                            localData := "No." + '_' + Name + '_' + UserSetup."IP Address";
                                            data += httpUtility.UrlEncode(localData, encoding.GetEncoding('ISO-8859-1'));

                                            stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/x-www-form-urlencoded');

                                            ReturnValue := RESTWSManagement.CallRESTWebService(CateringSetup."Biometrics API Endpoint",
                                                                                               'export.php',
                                                                                               'POST',
                                                                                               stringContent,
                                                                                               HttpResponseMessage);
                                            Window.CLOSE;
                                            IF NOT ReturnValue THEN
                                                EXIT;

                                            result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
                                        end;
                    */
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 for Sales';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoAccount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Account';
                    Image = CoupledCustomer;
                    ToolTip = 'Open the coupled Dynamics 365 for Sales account.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    ApplicationArea = Suite;
                    Caption = 'Synchronize';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category9;
                    ToolTip = 'Send or get updated data to or from Dynamics 365 for Sales.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(Rec.RecordId);
                    end;
                }
                action(UpdateStatisticsInCRM)
                {
                    ApplicationArea = Suite;
                    Caption = 'Update Account Statistics';
                    Enabled = CRMIsCoupledToRecord;
                    Image = UpdateXML;
                    ToolTip = 'Send customer statistics data to Dynamics 365 for Sales to update the Account Statistics FactBox.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        Promoted = true;
                        PromotedCategory = Category9;
                        ToolTip = 'Create or modify the coupling to a Dynamics 365 for Sales account.';
                        Visible = CRMIntegrationEnabled;

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(Rec.RecordId);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        ApplicationArea = Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Dynamics 365 for Sales account.';
                        Visible = CRMIntegrationEnabled;

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(Rec.RecordId);
                        end;
                    }
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the customer table.';
                    Visible = CRMIntegrationEnabled;

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(Rec.RecordId);
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.")
                                  ORDER(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action(Action76)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Statistics';
                    Image = Statistics;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("S&ales")
                {
                    ApplicationArea = Advanced;
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ToolTip = 'View a summary of customer ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.';
                }
                action("Entry Statistics")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ToolTip = 'View entry statistics for the record.';
                }
                action("Statistics by C&urrencies")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Statistics by C&urrencies';
                    Image = Currencies;
                    RunObject = Page "Cust. Stats. by Curr. Lines";
                    RunPageLink = "Customer Filter" = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Date Filter" = FIELD("Date Filter");
                    ToolTip = 'View statistics for customers that use multiple currencies.';
                }
                action("Item &Tracking Entries")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;
                    ToolTip = 'View serial or lot numbers that are assigned to items.';

                    trigger OnAction()
                    begin
                        //      ItemTrackingDocMgt.ShowItemTrackingForMasterData(1, "No.", '', '', '', '', '');
                    end;
                }
                separator(Separator140) { }
            }
            group("Prices and Discounts")
            {
                Caption = 'Prices and Discounts';
                action("Invoice &Discounts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoice &Discounts';
                    Image = CalculateInvoiceDiscount;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category7;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                    ToolTip = 'Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.';
                }


            }
            group(ActionGroup82)
            {
                Caption = 'S&ales';
                Image = Sales;
                action("Prepa&yment Percentages")
                {
                    ApplicationArea = Prepayments;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    ToolTip = 'View or edit the percentages of the price that can be paid as a prepayment. ';
                }
                action("Recurring Sales Lines")
                {
                    ApplicationArea = Suite;
                    Caption = 'Recurring Sales Lines';
                    Ellipsis = true;
                    Image = CustomerCode;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category5;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No." = FIELD("No.");
                    ToolTip = 'Set up recurring sales lines for the customer, such as a monthly replenishment order, that can quickly be inserted on a sales document for the customer.';
                }
            }


        }

        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                Visible = OpenApprovalEntriesExistCurrUser;
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistCurrUser;


                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;

                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;


                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;

                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;


                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;

                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistCurrUser;


                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = (NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    ToolTip = 'Request approval to change the record.';


                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;

                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';


                }
                group(Flow)
                {
                    Caption = 'Flow';
                    action(CreateFlow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create a Flow';
                        Image = Flow;
                        Promoted = true;

                        PromotedOnly = true;
                        ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                        Visible = IsSaaS;

                        trigger OnAction()
                        var
                            FlowServiceManagement: Codeunit "Flow Service Management";
                            FlowTemplateSelector: Page "Flow Template Selector";
                        begin
                            // Opens page 6400 where the user can use filtered templates to create new flows.
                            FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetCustomerTemplateFilter);
                            FlowTemplateSelector.Run;
                        end;
                    }
                    action(SeeFlows)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'See my Flows';
                        Image = Flow;
                        Promoted = true;
                        PromotedCategory = Category6;
                        PromotedOnly = true;
                        RunObject = Page "Flow Selector";
                        ToolTip = 'View and configure Flows that you created.';
                    }
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';
                action(CreateApprovalWorkflow)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Create Approval Workflow';
                    Enabled = NOT EnabledApprovalWorkflowsExist;
                    Image = CreateWorkflow;
                    ToolTip = 'Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.';

                    trigger OnAction()
                    begin
                        PAGE.RunModal(PAGE::"Cust. Approval WF Setup Wizard");
                    end;
                }
                action(ManageApprovalWorkflows)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Manage Approval Workflows';
                    Enabled = EnabledApprovalWorkflowsExist;
                    Image = WorkflowSetup;
                    ToolTip = 'View or edit existing approval workflows for creating or changing customers.';

                    trigger OnAction()
                    var
                        WorkflowManagement: Codeunit "Workflow Management";
                    begin
                        WorkflowManagement.NavigateToWorkflows(DATABASE::Customer, EventFilter);
                    end;
                }
            }

            group(Student_Finance)
            {
                Caption = 'Students Finance';


                action("Make Payment")
                {
                    Caption = 'Make Payment';
                    Image = Payment;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Make Payment action.';
                    // Visible = canReceipt;

                    trigger OnAction()
                    var
                        StudBilling: Codeunit "Student Billing";
                    begin
                        //BILLING
                        /* if UserRec.get(Database.UserId) then
                            UserRec.TestField("Can Receipt Student", true)
                        else
                            error('Pleas e note that you dont have the rights to post student receipts');
*/
                        AccPayment := false;
                        StudentCharges.Reset;
                        StudentCharges.SetRange(StudentCharges."Student No.", Rec."No.");
                        StudentCharges.SetRange(StudentCharges.Recognized, false);
                        StudentCharges.SetFilter(StudentCharges.Code, '<>%1', '');
                        if StudentCharges.Find('-') then begin
                            if Confirm('Un-billed charges will be posted. Do you wish to continue?', false) = true then
                                StudBilling.BillStudent(Rec."No.")
                            else
                                error('Process Aborted');
                        end;
                        //BILLING

                        StudentPayments.Reset;
                        StudentPayments.SetRange(StudentPayments."Student No.", Rec."No.");
                        if StudentPayments.Find('-') then
                            StudentPayments.DeleteAll;

                        StudentPayments.Init;
                        StudentPayments."Student No." := Rec."No.";
                        StudentPayments."Transaction Date" := Today;
                        StudentPayments.Insert;

                        StudentPayments.Reset;
                        StudentPayments.SetRange(StudentPayments."Student No.", Rec."No.");
                        if AccPayment = true then begin
                            if Cust.Get(Rec."No.") then
                                Cust."Application Method" := Cust."Application Method"::"Apply to Oldest";
                            Cust.Modify;
                        end;

                        PAGE.Run(54816, StudentPayments);

                        if Cust.GLN <> '' then begin
                            Receipts.Reset;
                            Receipts.SetCurrentkey(Receipts."Receipt No.");
                            Receipts.SetRange(Receipts."Receipt No.", cust.GLN);
                            if Receipts.Find('-') then begin
                                if Confirm('Do you want to print the receipt?', true) then
                                    Report.Run(70134858, true, true, Receipts);
                            end;

                        end;
                    end;
                }
                action(Receipting)
                {
                    Caption = 'Receipting';
                    Image = Receipt;
                    ShortCutKey = 'F9';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Executes the Receipting action.';
                    trigger OnAction()
                    begin

                        StudentPayments.Reset;
                        StudentPayments.SetRange(StudentPayments."Student No.", Rec."No.");
                        if StudentPayments.Find('-') then
                            StudentPayments.DeleteAll;

                        StudentPayments.Init;
                        StudentPayments."Student No." := Rec."No.";
                        StudentPayments."Transaction Date" := Today;
                        StudentPayments.Insert;

                        StudentPayments.Reset;
                        StudentPayments.SetRange(StudentPayments."Student No.", Rec."No.");
                        if AccPayment = true then begin
                            if Cust.Get(Rec."No.") then
                                Cust."Application Method" := Cust."Application Method"::"Apply to Oldest";
                            Cust.Modify;
                        end;

                        PAGE.Run(70134816, StudentPayments);
                    end;
                }
                action("Student Receipts")
                {
                    ApplicationArea = All;
                    Caption = 'Student Receipts';
                    Image = BOMRegisters;
                    RunObject = Page Receipts;
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Student Receipts action.';
                }

                action(Action123)
                {
                    Caption = 'Print Statement';
                    Image = CustomerLedger;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Print Statement action.';
                    trigger OnAction()
                    begin
                        Cust.Reset;
                        Cust.SetFilter(Cust."No.", Rec."No.");
                        if Cust.Find('-') then
                            REPORT.Run(70135058, true, true, Cust);
                    end;
                }
                action(Action126)
                {
                    Caption = 'Bill Booked Units';
                    Image = PostedPutAway;
                    ApplicationArea = basic;
                    ToolTip = 'Executes the Bill Booked Units action.';
                    trigger OnAction()
                    var
                        Creg: Record "Course Registration";

                    begin
                        Creg.Reset;
                        Creg.SetFilter(Creg."Student No.", Rec."No.");
                        // Creg.SetFilter(Creg.Semester, Semester);
                        if Creg.Find('-') then
                            REPORT.Run(70135657, true, true, Creg);
                    end;
                }

            }

        }

    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        CreateCustomerFromTemplate;
        ActivateFields;
        StyleTxt := Rec.SetStyle;
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        if CRMIntegrationEnabled then begin
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
            if Rec."No." <> xRec."No." then
                CRMIntegrationManagement.SendResultNotification(Rec);
        end;


        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer, EventFilter);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);


    end;

    trigger OnAfterGetRecord()
    var
        AgedAccReceivable: Codeunit "Aged Acc. Receivable";
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
        BalanceExhausted := 10000 <= Rec.CalcCreditLimitLCYExpendedPct;
        DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage(Rec."No.");
        AttentionToPaidDay := DaysPastDueDate > 0;

        Rec."Enrolled Programmes" := Rec."Current Programme";
        Rec.CalcFields("Programme GPA Points");
        Rec.CalcFields("Completed Units");
        //  CalcFields("Programme GPA Count");
        if (Rec."Programme GPA Points" > 0) and (Rec."Completed Units" > 0) then
            Rec."Cumm GPA" := Rec."Programme GPA Points" / Rec."Completed Units";

    end;

    trigger OnInit()
    begin
        //FoundationOnly := ApplicationAreaSetup.IsFoundationEnabled;

        SetCustomerNoVisibilityOnFactBoxes;

        ContactEditable := true;

        OpenApprovalEntriesExistCurrUser := true;


        CaptionTxt := CurrPage.Caption;
        SetCaption(CaptionTxt);
        CurrPage.Caption(CaptionTxt);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if UserRec.Get(DATABASE.UserId) then begin

            if UserRec."Can Create Student" = false then Error('Please note that you dont have the rights to create a Student!');
        end else begin
            Error('Please note that you dont have the rights to create a Student!');
        end;
        /*
        //IF GUIALLOWED THEN
          IF "No." = '' THEN
            IF DocumentNoVisibility.CustomerNoSeriesIsDefault THEN
              NewMode := TRUE;
          */
        Rec."Customer Type" := Rec."Customer Type"::Student;
        Rec."Gen. Bus. Posting Group" := 'LOCAL';
        Rec."Customer Posting Group" := 'STUDENT';
        Rec."Application Method" := Rec."Application Method"::"Apply to Oldest";

    end;

    trigger OnOpenPage()
    var
        OfficeManagement: Codeunit "Office Management";

    begin
        ActivateFields;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        SetNoFieldVisible;
        IsOfficeAddin := OfficeManagement.IsAvailable;
        // IsSaaS := PermissionManager.SoftwareAsAService;

        Rec."Enrolled Programmes" := Rec."Current Programme";
        CanReceipt := false;
        if UserRec.get(Database."UserID") then begin
            if UserRec."Can Receipt Student" = true then
                CanReceipt := true;
        end;



        ShowCharts := Rec."No." <> '';
        Rec.SetFilter("Date Filter", CustomerMgt.GetCurrentYearFilter);
    end;

    var

        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CustomerMgt: Codeunit "Customer Mgt.";
        StyleTxt: Text;
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        ShowCharts: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        NoFieldVisible: Boolean;
        BalanceExhausted: Boolean;
        AttentionToPaidDay: Boolean;
        IsOfficeAddin: Boolean;
        NoPostedInvoices: Integer;
        NoPostedCrMemos: Integer;
        NoOutstandingInvoices: Integer;
        NoOutstandingCrMemos: Integer;
        Totals: Decimal;
        AmountOnPostedInvoices: Decimal;
        AmountOnPostedCrMemos: Decimal;
        AmountOnOutstandingInvoices: Decimal;
        AmountOnOutstandingCrMemos: Decimal;
        AdjmtCostLCY: Decimal;
        AdjCustProfit: Decimal;
        CustProfit: Decimal;
        AdjProfitPct: Decimal;
        CustInvDiscAmountLCY: Decimal;
        CustPaymentsLCY: Decimal;
        CustSalesLCY: Decimal;
        DaysPastDueDate: Decimal;
        ShowMapLbl: Label 'Show on Map';
        FoundationOnly: Boolean;
        CanCancelApprovalForRecord: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        NewMode: Boolean;
        EventFilter: Text;
        CaptionTxt: Text;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsSaaS: Boolean;
        Cust: Record Customer;
        UserRec: Record "User Setup";
        StudentPayments: Record "Student Payments";
        StudentCharges: Record "Student Charges";
        Receipts: Record Receipt;
        AccPayment: Boolean;
        CanReceipt: Boolean;





    local procedure GetTotalSales(): Decimal
    begin
        NoPostedInvoices := 0;
        NoPostedCrMemos := 0;
        NoOutstandingInvoices := 0;
        NoOutstandingCrMemos := 0;
        Totals := 0;

        AmountOnPostedInvoices := CustomerMgt.CalcAmountsOnPostedInvoices(Rec."No.", NoPostedInvoices);
        AmountOnPostedCrMemos := CustomerMgt.CalcAmountsOnPostedCrMemos(Rec."No.", NoPostedCrMemos);

        AmountOnOutstandingInvoices := CustomerMgt.CalculateAmountsOnUnpostedInvoices(Rec."No.", NoOutstandingInvoices);
        AmountOnOutstandingCrMemos := CustomerMgt.CalculateAmountsOnUnpostedCrMemos(Rec."No.", NoOutstandingCrMemos);

        Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;

        CustomerMgt.CalculateStatistic(
          Rec,
          AdjmtCostLCY, AdjCustProfit, AdjProfitPct,
          CustInvDiscAmountLCY, CustPaymentsLCY, CustSalesLCY,
          CustProfit);
        exit(Totals)
    end;

    local procedure GetAmountOnPostedInvoices(): Decimal
    begin
        exit(AmountOnPostedInvoices)
    end;

    local procedure GetAmountOnCrMemo(): Decimal
    begin
        exit(AmountOnPostedCrMemos)
    end;

    local procedure GetAmountOnOutstandingInvoices(): Decimal
    begin
        exit(AmountOnOutstandingInvoices)
    end;

    local procedure GetAmountOnOutstandingCrMemos(): Decimal
    begin
        exit(AmountOnOutstandingCrMemos)
    end;

    local procedure GetMoneyOwedExpected(): Decimal
    begin
        exit(CustomerMgt.CalculateAmountsWithVATOnUnpostedDocuments(Rec."No."))
    end;



    local procedure ActivateFields()
    begin
        SetSocialListeningFactboxVisibility;
        ContactEditable := Rec."Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
    //   SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        //  SocialListeningMgt.GetCustFactboxVisibility(Rec, SocialListeningSetupVisible, SocialListeningVisible);
    end;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
    end;

    local procedure SetCustomerNoVisibilityOnFactBoxes()
    begin
        // CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(false);
        // CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(false);
        // CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(false);
    end;

    //[Scope('Personalization')]
    procedure RunReport(ReportNumber: Integer; CustomerNumber: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.SetRange("No.", CustomerNumber);
        REPORT.RunModal(ReportNumber, true, true, Customer);
    end;

    local procedure CreateCustomerFromTemplate()
    begin
        OnBeforeCreateCustomerFromTemplate(NewMode);
        NewMode := false;
    end;


    [IntegrationEvent(false, false)]
    procedure SetCaption(var InText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCustomerFromTemplate(var NewMode: Boolean)
    begin
    end;




}

