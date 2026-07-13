Page 50110 "Students Hostel Header Clear"
{
    Editable = true;
    PageType = Document;
    SourceTable = Customer;
    SourceTableView = where("Customer Type" = const(Student));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field(Control1000000001; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.(*)';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(EntryIntake; Rec."Entry Intake")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry Intake field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(IDNo; Rec."ID No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID No field.';
                }
                field(DateRegistered; Rec."Date Registered")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Registered field.';
                }
                field(PaymentsBy; Rec."Payments By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payments By field.';
                }
                field(MembershipNo; Rec."Membership No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Membership No field.';
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Citizenship field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(HostelBlackListed; Rec."Hostel Black Listed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel Black Listed field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(MaritalStatus; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Religion field.';
                }
                field(PostingGroup; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field(DebitAmountLCY; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Debit Amount (LCY) field.';
                }
                field(CreditAmountLCY; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Credit Amount (LCY) field.';
                }
                field(BalanceLCY; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.", Rec."No.");
                        Rec.Copyfilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Rec.Copyfilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Rec.Copyfilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(HELBNo; Rec."HELB No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HELB No. field.';
                }
                field(Picture; Rec.Image)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the picture of the customer, for example, a logo.';
                }
            }
            group(ContactDetails)
            {
                Caption = 'Contact Details';
                Editable = false;
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional address information.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s city.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(TelexNo; Rec."Telex No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telex No. field.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s fax number.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ClearStudentRoom)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Student Room';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                ToolTip = 'Executes the Clear Student Room action.';

                trigger OnAction()
                begin
                    Rec.TestField("Hostel Black Listed", false);
                    "Book Room"();
                end;
            }
            action(StudentRoom)
            {
                ApplicationArea = Basic;
                Caption = 'Student Room';
                Image = List;
                Promoted = true;
                RunObject = Page "Student Hostel Rooms Clear";
                RunPageLink = Student = field("No.");
                ToolTip = 'Executes the Student Room action.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // CalcFields("Total Billed", "Total Paid");
        // CurrentBill := "Total Billed" - "Total Paid";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Customer Type" := Rec."customer type"::Student;
        Rec."Date Registered" := Today;
    end;

    var
        acadYear: Record "Academic Year";
        semz: Record Semesters;
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        ChargesRec: Record Charge;
        PaidAmt: Decimal;
        NoRoom: Integer;
        StudentHostel: Record "Students Hostel Rooms";
        StudentCharges: Record "Student Charges";
        Rooms_Spaces: Record "Room Spaces";
        Hostel_Rooms: Record "Hostel Block Rooms";
        Host_Ledger: Record "Hostel Ledger";
        counts: Integer;

    procedure "Book Room"()
    begin
        // --------Check If More Than One Room Has Been Selected


        StudentHostel.Reset;
        NoRoom := 0;
        StudentHostel.SetRange(StudentHostel.Student, Rec."No.");
        StudentHostel.SetRange(StudentHostel.Billed, false);
        StudentHostel.SetFilter(StudentHostel."Space No", '<>%1', '');
        if StudentHostel.Find('-') then begin
            repeat
                // Get the Hostel Name
                StudentHostel.TestField(StudentHostel.Semester);
                StudentHostel.TestField(StudentHostel."Academic Year");
                StudentHostel.TestField(StudentHostel."Space No");
                NoRoom := NoRoom + 1;
                if NoRoom > 1 then begin
                    Error('Please Note That You Can Not Select More Than One Room')
                end;
                // check if the room is still vacant
                Rooms_Spaces.Reset;
                Rooms_Spaces.SetRange(Rooms_Spaces."Space Code", StudentHostel."Space No");
                Rooms_Spaces.SetRange(Rooms_Spaces."Room Code", StudentHostel."Room No");
                Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code", StudentHostel."Hostel No");
                if Rooms_Spaces.Find('-') then
                    if Rooms_Spaces.Status <> Rooms_Spaces.Status::Vaccant then Error('The selected room is nolonger vacant');

                // ----------Check If He has UnCleared Room
                StudentHostel.Reset;
                StudentHostel.SetRange(StudentHostel.Student, Rec."No.");
                StudentHostel.SetRange(StudentHostel.Cleared, false);
                if StudentHostel.Find('-') then begin
                    if StudentHostel.Count > 1 then begin
                        Error('Please Note That You Must First Clear Your Old Rooms Before You Book Another Room')
                    end;
                end;
                //---Check if The Student Have Paid The Accomodation Fee
                StudentCharges.Reset;
                StudentCharges.SetRange(StudentCharges."Student No.", StudentHostel.Student);
                StudentCharges.SetRange(StudentCharges.Semester, StudentHostel.Semester);
                StudentCharges.SetRange(Posted, true);
                if StudentCharges.Find('-') then begin
                    ChargesRec.SetRange(ChargesRec.Code, StudentCharges.Code);
                    if ChargesRec.Find('-') then begin
                        PaidAmt := ChargesRec.Amount
                    end;
                end;
                if PaidAmt > StudentHostel."Accomodation Fee" then begin
                    StudentHostel."Over Paid" := true;
                    StudentHostel."Over Paid Amt" := PaidAmt - StudentHostel."Accomodation Fee";
                    StudentHostel.Modify;
                    /*
                     END ELSE BEGIN
                       IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN

                        ERROR('Accomodation Fee Paid Can Not Book This Room The Paid Amount is '+FORMAT(PaidAmt))
                       END;
                       */
                end;


                Rooms_Spaces.Reset;
                Rooms_Spaces.SetRange(Rooms_Spaces."Space Code", StudentHostel."Space No");
                if Rooms_Spaces.Find('-') then begin
                    Rooms_Spaces.Status := Rooms_Spaces.Status::"Fully Occupied";
                    Rooms_Spaces.Modify;
                    Clear(counts);
                    // Post to  the Ledger Tables
                    Host_Ledger.Reset;
                    if Host_Ledger.Find('-') then counts := Host_Ledger.Count;
                    Host_Ledger.Init;
                    Host_Ledger."Space No" := StudentHostel."Space No";
                    Host_Ledger."Room No" := StudentHostel."Room No";
                    Host_Ledger."Hostel No" := StudentHostel."Hostel No";
                    Host_Ledger.No := counts;
                    Host_Ledger.Status := Host_Ledger.Status::"Fully Occupied";
                    Host_Ledger."Room Cost" := StudentHostel.Charges;
                    Host_Ledger."Student No" := StudentHostel.Student;
                    Host_Ledger."Receipt No" := '';
                    Host_Ledger.Semester := StudentHostel.Semester;
                    Host_Ledger.Gender := Rec.Gender;
                    Host_Ledger."Hostel Name" := '';
                    Host_Ledger.Campus := Rec."Global Dimension 1 Code";
                    Host_Ledger."Academic Year" := StudentHostel."Academic Year";
                    Host_Ledger.Insert(true);


                    Hostel_Rooms.Reset;
                    Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code", StudentHostel."Hostel No");
                    Hostel_Rooms.SetRange(Hostel_Rooms."Room Code", StudentHostel."Room No");
                    if Hostel_Rooms.Find('-') then begin
                        Hostel_Rooms.CalcFields(Hostel_Rooms."Bed Spaces", Hostel_Rooms."Occupied Spaces");
                        if Hostel_Rooms."Bed Spaces" = Hostel_Rooms."Occupied Spaces" then
                            Hostel_Rooms.Status := Hostel_Rooms.Status::"Fully Occupied"
                        else
                            if Hostel_Rooms."Occupied Spaces" < Hostel_Rooms."Bed Spaces" then
                                Hostel_Rooms.Status := Hostel_Rooms.Status::"Partially Occupied";
                        Hostel_Rooms.Modify;
                    end;

                    StudentHostel.Billed := true;
                    StudentHostel."Billed Date" := Today;
                    StudentHostel."Allocation Date" := Today;
                    StudentHostel.Allocated := true;
                    StudentHostel.Modify;


                end;
            //  IF StudentHostel."Over Paid" THEN BEGIN
            //    PostOverPayment();
            // END;
            until StudentHostel.Next = 0;
            Message('Room Booked Successfully');
        end;

    end;

    procedure PostOverPayment()
    begin
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", 'CHARGES');
        if GenJnlLine.Find('-') then begin
            GenJnlLine.DeleteAll
        end;

        StudentHostel.Reset;
        StudentHostel.SetRange(StudentHostel.Student, Rec."No.");
        StudentHostel.SetRange(StudentHostel.Cleared, false);
        if StudentHostel.Find('-') then begin
            repeat
                StudentHostel.TestField(StudentHostel.Semester);
                StudentHostel.TestField(StudentHostel."Space No");
                //IF StudentHostel.Charges>0 THEN BEGIN
                LineNo := LineNo + 1000;
                GenJnlLine.Init;
                GenJnlLine."Journal Template Name" := 'PAYMENTs';
                GenJnlLine."Journal Batch Name" := 'CHARGES';
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
                GenJnlLine."Account No." := Rec."No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Posting Date" := Today;
                GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := StudentHostel."Space No" + ' ' + StudentHostel."Room No";
                //GenJnlLine."External Document No.":="Cheque No";
                GenJnlLine.Amount := -StudentHostel."Over Paid Amt";
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '300202';
                GenJnlLine.Description := Rec.Name;
                GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                GenJnlLine."Shortcut Dimension 1 Code" := 'ACADEMIC';
                //GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                //GenJnlLine."Document No.":="Doc No";
                if GenJnlLine.Amount <> 0 then
                    GenJnlLine.Insert;
            //END;
            until StudentHostel.Next = 0;
        end;
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", 'CHARGES');
        if GenJnlLine.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
        end;
    end;

    procedure CheckClearence()
    begin
    end;

    procedure GetCurrentYear() currYear: Code[20]
    begin
        acadYear.Reset;
        acadYear.SetRange(acadYear.Current, true);
        if acadYear.Find('-') then begin
            currYear := acadYear.Code;
        end;
    end;

    procedure GetCurrsEM() currsem: Code[20]
    begin
        semz.Reset;
        semz.SetRange(semz."Current Semester", true);
        if semz.Find('-') then begin
            currsem := semz.Code;
        end;
    end;
}

