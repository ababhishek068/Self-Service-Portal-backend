page 50956 "Student Billing List"
{
    Caption = 'All Students List';
    CardPageID = "Students Billing";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTableView = WHERE("Customer Type" = CONST(Student),
                            Status = FILTER(Registration | Current | Suspended));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }

                field("Application No."; Rec."Application No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application No. field.';
                }
                field("ID No"; Rec."ID No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID No field.';
                }




                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    Caption = 'Town';
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.';
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                }

                field("Catering Amount"; Rec."Catering Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Catering Amount field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Registration2)
            {
                Caption = 'Registration';
                action("Registration")
                {
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Course Registration List";
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Registration action.';
                }

                action(Receipts)
                {
                    Caption = 'Receipts';
                    Image = Receipt;
                    Promoted = true;
                    RunObject = Page Receipts;
                    RunPageLink = "Student No." = FIELD("No.");
                    ToolTip = 'Executes the Receipts action.';
                }
            }

            group("&Student")
            {
                Caption = '&Student';

                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Visible = false;
                    action("Issued &Reminders")
                    {
                        Caption = 'Issued &Reminders';
                        RunObject = Page "Issued Reminder";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        Visible = false;
                        ToolTip = 'Executes the Issued &Reminders action.';
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        Caption = 'Issued &Finance Charge Memos';
                        RunObject = Page "Issued Finance Charge Memo";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                        Visible = false;
                        ToolTip = 'Executes the Issued &Finance Charge Memos action.';
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'Executes the Dimensions action.';
                }
                action("Bank Accounts")
                {
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account Card";
                    RunPageLink = "Customer No." = FIELD("No.");
                    ToolTip = 'Executes the Bank Accounts action.';
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    RunObject = Page "Ship-to Address";
                    RunPageLink = "Customer No." = FIELD("No.");
                    Visible = false;
                    ToolTip = 'Executes the Ship-&to Addresses action.';
                }
                action("C&ontact")
                {
                    Caption = 'C&ontact';
                    Image = ContactPerson;
                    ToolTip = 'Executes the C&ontact action.';

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
                separator(Separator1000000027) { }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }

                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Visible = false;
                    ToolTip = 'Executes the Entry Statistics action.';
                }
                separator(Separator1000000023)
                {
                    Caption = '';
                }
                separator(Separator1000000022)
                {
                    Caption = '';
                }
                action("Ser&vice Contracts")
                {
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Customer Service Contracts";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code");
                    Visible = false;
                    ToolTip = 'Executes the Ser&vice Contracts action.';
                }
                action("Service &Items")
                {
                    Caption = 'Service &Items';
                    RunObject = Page "Service Items";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.", "Ship-to Code", "Item No.", "Serial No.");
                    Visible = false;
                    ToolTip = 'Executes the Service &Items action.';
                }
                separator(Separator1000000019) { }
                action("&Jobs")
                {
                    Caption = '&Jobs';
                    RunObject = Page "Job Card";
                    RunPageLink = "Bill-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Bill-to Customer No.");
                    Visible = false;
                    ToolTip = 'Executes the &Jobs action.';
                }
                separator(Separator1000000017) { }
            }
            group("&Transact")
            {
                Caption = '&Transact';
                action(Receipting)
                {
                    Caption = 'Receipting';
                    Image = Receipt;
                    RunObject = Page "Student Payments Form";
                    RunPageLink = "Student No." = FIELD("No.");
                    ShortCutKey = 'F9';
                    ToolTip = 'Executes the Receipting action.';
                }

            }



            action("Make Payment")
            {
                Caption = 'Make Payment';
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Make Payment action.';

                trigger OnAction()
                var
                    StudBilling: Codeunit "Student Billing";
                begin
                    //BILLING
                    if UserRec.get(Database.UserId) then
                        UserRec.TestField("Can Receipt Student", true)
                    else
                        error('Please note that you dont have the rights to post student receipts');

                    AccPayment := false;
                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", Rec."No.");
                    StudentCharges.SetRange(StudentCharges.Recognized, false);
                    StudentCharges.SetFilter(StudentCharges.Code, '<>%1', '');
                    if StudentCharges.Find('-') then begin
                        if Confirm('Un-billed charges will be posted. Do you wish to continue?', false) = true then
                            StudBilling.BillStudent(Rec."No.");
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

                    PAGE.Run(70134816, StudentPayments);

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
            action("Print Statement")
            {
                Caption = 'Print Statement';
                Image = CustomerLedger;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                ToolTip = 'Executes the Print Statement action.';

                trigger OnAction()
                begin
                    Cust.Reset;
                    Cust.SetFilter(Cust."No.", Rec."No.");
                    if Cust.Find('-') then
                        REPORT.Run(70135058, true, true, Cust);
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        /*
        if UserRec.Get(DATABASE.UserId) then
            if UserRec."Shortcut Dimension 3 Code" <> '' then
                SetFilter("School Code", UserRec."Shortcut Dimension 3 Code");
        if UserRec."Global Dimension 1 Code" <> '' then
            SetFilter("Global Dimension 1 Code", UserRec."Global Dimension 1 Code");
            */
    end;

    var
        StudentPayments: Record "Student Payments";
        StudentCharges: Record "Student Charges";
        Cust: Record Customer;
        Receipts: Record Receipt;
        AccPayment: Boolean;
        UserRec: Record "User Setup";

    procedure GetSelectionFilter(): Code[80]
    var
        Cust: Record Customer;
        FirstCust: Code[30];
        LastCust: Code[30];
        SelectionFilter: Code[250];
        CustCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Cust);
        CustCount := Cust.Count;
        if CustCount > 0 then begin
            Cust.Find('-');
            while CustCount > 0 do begin
                CustCount := CustCount - 1;
                Cust.MarkedOnly(false);
                FirstCust := Cust."No.";
                LastCust := FirstCust;
                More := (CustCount > 0);
                while More do
                    if Cust.Next = 0 then
                        More := false
                    else
                        if not Cust.Mark then
                            More := false
                        else begin
                            LastCust := Cust."No.";
                            CustCount := CustCount - 1;
                            if CustCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstCust = LastCust then
                    SelectionFilter := SelectionFilter + FirstCust
                else
                    SelectionFilter := SelectionFilter + FirstCust + '..' + LastCust;
                if CustCount > 0 then begin
                    Cust.MarkedOnly(true);
                    Cust.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

    procedure SetSelection(var Cust: Record Customer)
    begin
        CurrPage.SetSelectionFilter(Cust);
    end;
}

