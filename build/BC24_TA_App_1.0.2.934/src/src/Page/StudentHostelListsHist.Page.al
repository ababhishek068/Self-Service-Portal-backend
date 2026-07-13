Page 50105 "Student Hostel Lists Hist"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type" = const(Student),
                            "Hostel Allocated" = filter(true),
                            "Billed Hostel" = filter(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field(HostelNo; Rec."Hostel No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel No. field.';
                }
                field(RoomCode; Rec."Room Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Code field.';
                }
                field(SpaceBooked; Rec."Space Booked")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Space Booked field.';
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
                field(BalanceLCY; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
                }
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
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s city.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field(OurAccountNo; Rec."Our Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Our Account No. field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PostCharges)
            {
                ApplicationArea = Basic;
                Caption = 'Post Charges';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Post Charges action.';

                trigger OnAction()
                begin
                    if Confirm('Do You Really Want to Post The Room Charges') then begin
                        GenSetUp.Get();
                        if GenSetUp.Find('-') then begin
                            NoSeries.Reset;
                            NoSeries.SetRange(NoSeries."Series Code", GenSetUp."Transaction Nos.");
                            if NoSeries.Find('-') then begin
                                LastNo := NoSeries."Last No. Used"
                            end;
                        end;
                        StudentHostel.Reset;
                        StudentHostel.SetRange(StudentHostel.Student, Rec."No.");
                        StudentHostel.SetRange(StudentHostel.Billed, false);
                        if StudentHostel.Find('-') then begin
                            repeat
                                ;
                                //message(LastNo);
                                LastNo := IncStr(LastNo);
                                NoSeries."Last No. Used" := LastNo;
                                NoSeries.Modify;
                                StudentCharges.Init();
                                StudentCharges."Transacton ID" := LastNo;
                                StudentCharges.Validate(StudentCharges."Transacton ID");
                                StudentCharges."Student No." := Rec."No.";
                                StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                                StudentCharges.Description := 'Hostel Charges ' + StudentHostel."Space No";
                                StudentCharges.Amount := StudentHostel."Accomodation Fee";
                                StudentCharges.Date := StudentHostel."Allocation Date";
                                StudentCharges.Code := 'ACC';
                                StudentCharges.Charge := true;
                                StudentCharges.Insert(true);
                                StudentHostel.Billed := true;
                                StudentHostel."Billed Date" := Today;
                                StudentHostel.Modify;
                            until StudentHostel.Next = 0;
                        end;
                        Message('Hostel Charges Posted Successfully');
                    end;
                end;
            }
            action(StudentRoom)
            {
                ApplicationArea = Basic;
                Caption = 'Student Room';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Student Hostel Rooms Posted";
                RunPageLink = Student = field("No.");
                ToolTip = 'Executes the Student Room action.';
            }
            action("Print Invoice")
            {
                ApplicationArea = Basic;
                Image = Invoice;
                Promoted = true;
                ToolTip = 'Executes the Print Invoice action.';

                trigger OnAction()
                begin

                    Allocations.Reset;
                    Allocations.SetRange(Allocations.Student, Rec."No.");
                    Allocations.SetRange(Allocations."Hostel No", Rec."Hostel No.");
                    Allocations.SetRange(Allocations."Room No", Rec."Room Code");
                    Allocations.SetRange(Allocations."Space No", Rec."Space Booked");
                    //  allocations.SETRANGE(allocations."Academic Year","Academic Year");
                    // Allocations.SetRange(Allocations.Semester, Semester);
                    if Allocations.Find('-') then
                        Report.Run(70135094, true, false, Allocations);
                end;
            }
            action(Post_Charge)
            {
                ApplicationArea = Basic;
                Caption = 'Create/Post Charges';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create/Post Charges action.';

                trigger OnAction()
                var
                    studRooms: Record "Students Hostel Rooms";
                begin
                    CReg.Reset;
                    CReg.SetRange(CReg."Student No.", Rec."No.");
                    //  CReg.SetRange(CReg.Semester, Semester);
                    if CReg.Find('-') then begin
                        studRooms.Reset;
                        studRooms.SetRange(studRooms.Student, Rec."No.");
                        studRooms.SetRange(studRooms."Space No", Rec."Space Booked");
                        studRooms.SetRange(studRooms."Room No", Rec."Room Code");
                        studRooms.SetRange(studRooms."Hostel No", Rec."Hostel No.");
                        studRooms.SetRange(studRooms.Semester, CReg.Semester);
                        if studRooms.Find('-') then begin
                            repeat
                            begin
                                postCharge(studRooms);
                            end;
                            until studRooms.Next = 0;
                        end;
                    end;
                    // Post the Journal
                end;
            }
            separator(Action25) { }
            action("Hostel Clearance")
            {
                ApplicationArea = Basic;
                Image = CancelAllLines;
                RunObject = Page "Students Hostel Header Clear";
                ToolTip = 'Executes the Hostel Clearance action.';
            }
        }
    }

    var
        acadYear: Record "Academic Year";
        semz: Record Semesters;
        Stages: Record "Programme Stages";
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        NoSeries: Record "No. Series Line";
        CReg: Record "Course Registration";
        LastNo: Code[20];
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        DueDate: Date;
        StudentHostel: Record "Students Hostel Rooms";
        StudentCharges: Record "Student Charges";
        GenSetUp: Record "General Set-Up";
        Allocations: Record "Students Hostel Rooms";
        AccPayment: Boolean;
        charges1: Record Charge;
        GenJnl: Record "Gen. Journal Line";
        prog: Record Programme;
        "Settlement Typ": Record "Settlement Type";

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

    procedure "Book Room"(var settle_m: Option " ",JAB,SSP,"Special Programme")
    begin
        // --------Check If More Than One Room Has Been Selected
        /*
            CLEAR(billAmount);
           rooms.RESET;
          rooms.SETRANGE(rooms."Hostel Code",);
          rooms.SETRANGE(rooms."Room Code","Room No");
          IF rooms.FIND('-') THEN BEGIN
            IF settle_m=settle_m::"Special Programme" THEN
              billAmount:=rooms."Special Programme"
            ELSE IF settle_m=settle_m::JAB THEN
              billAmount:=rooms."JAB Fees"
            ELSE IF settle_m=settle_m::SSP THEN
              billAmount:=rooms."SSP Fees"
        
          END;
          Cust.RESET;
          Cust.SETRANGE(Cust."No.",Student);
          IF Cust.FIND('-') THEN BEGIN
          END;
        
          StudentHostel.RESET;
          NoRoom:=0;
          StudentHostel.SETRANGE(StudentHostel.Student,Cust."No.");
         // StudentHostel.SETRANGE(StudentHostel.Billed,FALSE);
          StudentHostel.SETFILTER(StudentHostel."Space No",'<>%1','');
          IF StudentHostel.FIND('-') THEN BEGIN
            REPEAT
            // Get the Hostel Name
            StudentHostel.TESTFIELD(StudentHostel.Semester);
           // StudentHostel.TESTFIELD(StudentHostel."Academic Year");
            StudentHostel.TESTFIELD(StudentHostel."Space No");
            NoRoom:=NoRoom+1;
            IF NoRoom>1 THEN BEGIN
              ERROR('Please Note That You Can Not Select More Than One Room')
            END;
            // check if the room is still vacant
            Rooms_Spaces.RESET;
            Rooms_Spaces.SETRANGE(Rooms_Spaces."Space Code",StudentHostel."Space No");
            Rooms_Spaces.SETRANGE(Rooms_Spaces."Room Code",StudentHostel."Room No");
            Rooms_Spaces.SETRANGE(Rooms_Spaces."Hostel Code",StudentHostel."Hostel No");
            IF Rooms_Spaces.FIND('-') THEN
            IF Rooms_Spaces.Status<>Rooms_Spaces.Status::Vaccant THEN ERROR('The selected room is nolonger vacant');
        
            // ----------Check If He has UnCleared Room
           StudentHostel.RESET;
           StudentHostel.SETRANGE(StudentHostel.Student,Cust."No.");
           StudentHostel.SETRANGE(StudentHostel.Cleared,FALSE);
           IF StudentHostel.FIND('-') THEN BEGIN
              IF StudentHostel.COUNT>1 THEN BEGIN
                ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
              END;
           END;
           //---Check if The Student Have Paid The Accomodation Fee
           charges1.RESET;
           charges1.SETRANGE(charges1.Hostel,TRUE);
           IF charges1.FIND('-') THEN BEGIN
           END ELSE ERROR('Accommodation not setup.');
        
           StudentCharges.RESET;
           StudentCharges.SETRANGE(StudentCharges."Student No.",Student);
           StudentCharges.SETRANGE(StudentCharges.Semester,Semester);
           StudentCharges.SETRANGE(StudentCharges.Code,charges1.Code);
           //StudentCharges.SETRANGE(Posted,TRUE);
          { IF StudentCharges.FIND('-') THEN BEGIN
             ChargesRec.SETRANGE(ChargesRec.Code,StudentCharges.Code);
             IF ChargesRec.FIND('-') THEN BEGIN
               PaidAmt:=ChargesRec.Amount
             END;
           END; }
           IF Blocks.GET("Hostel No") THEN BEGIN
           END;
        
           IF NOT StudentCharges.FIND('-') THEN BEGIN
        coReg.RESET;
        coReg.SETRANGE(coReg."Student No.",Student);
        coReg.SETRANGE(coReg.Semester,Semester);
        //coReg.SETRANGE(coReg."Academic Year","Academic Year");
        IF coReg.FIND('-') THEN BEGIN
            StudentCharges.INIT;
            StudentCharges."Transacton ID":='';
            StudentCharges.VALIDATE(StudentCharges."Transacton ID");
            StudentCharges."Student No.":=coReg."Student No.";
            StudentCharges."Reg. Transacton ID":=coReg."Reg. Transacton ID";
            StudentCharges."Transaction Type":=StudentCharges."Transaction Type"::Charges;
            StudentCharges.Code :=charges1.Code;
            StudentCharges.Description:='Accommodation Fees';
           // IF Blocks.GET("Hostel No") THEN
           // StudentCharges.Amount:=Blocks."Cost Per Occupant"
           // ELSE
            StudentCharges.Amount:=billAmount;
            StudentCharges.Date:=TODAY;
            StudentCharges.Programme:=coReg.Programme;
            StudentCharges.Stage:=coReg.Stage;
            StudentCharges.Semester:=coReg.Semester;
            StudentCharges.INSERT();
        END;
             END;
        
           IF PaidAmt>StudentHostel."Accomodation Fee" THEN BEGIN
               StudentHostel."Over Paid":=TRUE;
               StudentHostel."Over Paid Amt":=PaidAmt-StudentHostel."Accomodation Fee";
               StudentHostel.MODIFY;
          {
           END ELSE BEGIN
             IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN
        
              ERROR('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is '+FORMAT(PaidAmt))
             END;
             }
           END;
        
        
            Rooms_Spaces.RESET;
            Rooms_Spaces.SETRANGE(Rooms_Spaces."Space Code",StudentHostel."Space No");
            IF Rooms_Spaces.FIND('-') THEN BEGIN
              Rooms_Spaces.Status:=Rooms_Spaces.Status::"Fully Occupied";
              Rooms_Spaces.MODIFY;
              CLEAR(counts);
          // Post to  the Ledger Tables
          Host_Ledger.RESET;
          IF Host_Ledger.FIND('-') THEN counts:=Host_Ledger.COUNT;
          Host_Ledger.INIT;
            Host_Ledger."Space No":=StudentHostel."Space No";
            Host_Ledger."Room No":=StudentHostel."Room No";
            Host_Ledger."Hostel No":=StudentHostel."Hostel No";
            Host_Ledger.No:=counts;
            Host_Ledger.Status:=Host_Ledger.Status::"Fully Occupied";
            Host_Ledger."Room Cost":=StudentHostel.Charges;
            Host_Ledger."Student No":=StudentHostel.Student;
            Host_Ledger."Receipt No":='';
            Host_Ledger.Semester:=StudentHostel.Semester;
            Host_Ledger.Gender:= Gender;
            Host_Ledger."Hostel Name":='';
            Host_Ledger.Campus:=Cust."Global Dimension 1 Code";
            Host_Ledger."Academic Year":=StudentHostel."Academic Year";
          Host_Ledger.INSERT(TRUE);
        
        
        Hostel_Rooms.RESET;
        Hostel_Rooms.SETRANGE(Hostel_Rooms."Hostel Code",StudentHostel."Hostel No");
        Hostel_Rooms.SETRANGE(Hostel_Rooms."Room Code",StudentHostel."Room No");
        IF Hostel_Rooms.FIND('-') THEN BEGIN
           Hostel_Rooms.CALCFIELDS(Hostel_Rooms."Bed Spaces",Hostel_Rooms."Occupied Spaces");
           IF Hostel_Rooms."Bed Spaces"=Hostel_Rooms."Occupied Spaces" THEN
            Hostel_Rooms.Status:=Hostel_Rooms.Status::"Fully Occupied"
           ELSE IF Hostel_Rooms."Occupied Spaces"<Hostel_Rooms."Bed Spaces" THEN
           Hostel_Rooms.Status:=Hostel_Rooms.Status::"Partially Occupied";
           Hostel_Rooms.MODIFY;
        END;
        
              StudentHostel.Billed:=TRUE;
              StudentHostel."Billed Date":=TODAY;
              StudentHostel."Allocation Date":=TODAY;
              StudentHostel.Allocated:=TRUE;
              StudentHostel.MODIFY;
        
        
            END;
          //  IF StudentHostel."Over Paid" THEN BEGIN
          //    PostOverPayment();
            // END;
            UNTIL StudentHostel.NEXT=0;
            MESSAGE('Room Allocateed Successfully');
          END;
            */

    end;

    local procedure postCharge(var studRooms: Record "Students Hostel Rooms")
    begin
        //BILLING
        if studRooms.Billed = true then
            Error('The Allocation is already posted.');
        charges1.Reset;
        charges1.SetRange(charges1.Hostel, true);
        if not charges1.Find('-') then begin
            Error('The charges Setup does not have an item tagged as Hostel.');
        end;

        AccPayment := false;
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", studRooms.Student);
        StudentCharges.SetRange(StudentCharges.Recognized, false);
        StudentCharges.SetFilter(StudentCharges.Code, '=%1', charges1.Code);
        if not StudentCharges.Find('-') then begin //3
                                                   // The charge does not exist. Created it, but check first if it exists as unrecognized
            StudentCharges.Reset;
            StudentCharges.SetRange(StudentCharges."Student No.", studRooms.Student);
            //StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
            StudentCharges.SetFilter(StudentCharges.Code, '=%1', charges1.Code);
            if not StudentCharges.Find('-') then begin //4
                                                       // Does not exist hence just create
                CReg.Reset;
                CReg.SetRange(CReg."Student No.", studRooms.Student);
                CReg.SetRange(CReg.Semester, studRooms.Semester);
                if CReg.Find('-') then begin //5
                    GenSetUp.Get();
                    if GenSetUp.Find('-') then begin  //6
                        NoSeries.Reset;
                        NoSeries.SetRange(NoSeries."Series Code", GenSetUp."Transaction Nos.");
                        if NoSeries.Find('-') then begin // 7
                            LastNo := NoSeries."Last No. Used"
                        end;  // 7
                    end; // 6
                         //message(LastNo);
                    LastNo := IncStr(LastNo);
                    NoSeries."Last No. Used" := LastNo;
                    NoSeries.Modify;
                    StudentCharges.Init();
                    StudentCharges."Transacton ID" := LastNo;
                    StudentCharges."Reg. Transacton ID" := CReg."Reg. Transacton ID";
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges."Student No." := studRooms.Student;
                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                    StudentCharges.Description := 'Hostel Charges ' + studRooms."Space No";
                    StudentCharges.Amount := studRooms.Charges;
                    StudentCharges.Date := Today;
                    StudentCharges.Code := charges1.Code;
                    StudentCharges.Charge := true;
                    StudentCharges.Insert(true);
                    studRooms.Billed := true;
                    studRooms."Billed Date" := Today;
                    studRooms.Modify;
                end; //5

            end else begin//4
                          // Charge Exists, Delete from the charges then create a new one
                StudentCharges.Delete;

                CReg.Reset;
                CReg.SetRange(CReg."Student No.", studRooms.Student);
                CReg.SetRange(CReg.Semester, studRooms.Semester);
                if CReg.Find('-') then begin //5
                    GenSetUp.Get();
                    if GenSetUp.Find('-') then begin  //6
                        NoSeries.Reset;
                        NoSeries.SetRange(NoSeries."Series Code", GenSetUp."Transaction Nos.");
                        if NoSeries.Find('-') then begin // 7
                            LastNo := NoSeries."Last No. Used"
                        end;  // 7
                    end; // 6
                         //message(LastNo);
                    LastNo := IncStr(LastNo);
                    NoSeries."Last No. Used" := LastNo;
                    NoSeries.Modify;
                    StudentCharges.Init();
                    StudentCharges."Transacton ID" := LastNo;
                    StudentCharges."Reg. Transacton ID" := CReg."Reg. Transacton ID";
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges."Student No." := studRooms.Student;
                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                    StudentCharges.Description := 'Hostel Charges ' + studRooms."Space No";
                    StudentCharges.Amount := studRooms.Charges;
                    StudentCharges.Date := Today;
                    StudentCharges.Code := charges1.Code;
                    StudentCharges.Charge := true;
                    StudentCharges.Insert(true);
                    studRooms.Billed := true;
                    studRooms."Billed Date" := Today;
                    studRooms.Modify;
                end; //5
            end;//4

        end; //3


        //SettlementType1:='';
        CReg.Reset;
        CReg.SetRange(CReg."Student No.", studRooms.Student);
        CReg.SetRange(CReg.Semester, studRooms.Semester);
        if CReg.Find('-') then begin //10
            "Settlement Typ".Get(CReg."Settlement Type");
            "Settlement Typ".TestField("Settlement Typ"."Tuition G/L Account");
        end // 10
        else begin // 10.1
            Error('The Settlement Type Does not Exists in the Course Registration for: ' + studRooms.Student);
        end;//10.1



        /*

        // MANUAL APPLICATION OF ACCOMODATION FOR PREPAYED STUDENTS BY Wanjala.....//
        StudentCharges.RESET;
        StudentCharges.SETRANGE(StudentCharges."Student No.",student);
        StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
        StudentCharges.SETFILTER(StudentCharges.Code,'=%1',Charges1.Code) ;

        IF StudentCharges.COUNT=1 THEN BEGIN
        CALCFIELDS(Balance);
        IF Balance<0 THEN BEGIN
        IF ABS(Balance)>StudentCharges.Amount THEN BEGIN
        "Application Method":="Application Method"::Manual;
        AccPayment:=TRUE;
        MODIFY;
        END;
        END;
        END; */

        //END;


        //ERROR('TESTING '+FORMAT("Application Method"));

        if Cust.Get(studRooms.Student) then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", 'SALES');
        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");

        // Charge Student - Accommodation- if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", studRooms.Student);
        StudentCharges.SetRange(StudentCharges.Recognized, false);
        StudentCharges.SetFilter(StudentCharges.Code, '=%1', charges1.Code);
        if StudentCharges.Find('-') then begin

            repeat

                DueDate := StudentCharges.Date;
                //IF Sems.GET(StudentCharges.Semester) THEN BEGIN
                //IF Sems.From<>0D THEN BEGIN
                //IF Sems.From > DueDate THEN
                //DueDate:=Sems.From;
                //END;
                //END;
                if DueDate = 0D then DueDate := Today;

                GenJnl.Init;
                GenJnl."Line No." := GenJnl."Line No." + 10000;
                GenJnl."Posting Date" := Today;
                GenJnl."Document No." := StudentCharges."Transacton ID";
                GenJnl.Validate(GenJnl."Document No.");
                GenJnl."Journal Template Name" := 'SALES';
                GenJnl."Journal Batch Name" := 'STUD PAY';
                GenJnl."Account Type" := GenJnl."account type"::Customer;
                //
                if Cust.Get(studRooms.Student) then begin
                    if Cust."Bill-to Customer No." <> '' then
                        GenJnl."Account No." := Cust."Bill-to Customer No."
                    else
                        GenJnl."Account No." := studRooms.Student;
                end;

                GenJnl.Amount := StudentCharges.Amount;
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description := StudentCharges.Description;
                GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                   (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No." := "Settlement Typ"."Tuition G/L Account";

                    CReg.Reset;
                    CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                    CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                    CReg.SetRange(CReg."Student No.", StudentCharges."Student No.");
                    if CReg.Find('-') then begin
                        if CReg."Register for" = CReg."register for"::Stage then begin
                            Stages.Reset;
                            Stages.SetRange(Stages."Programme Code", CReg.Programme);
                            Stages.SetRange(Stages.Code, CReg.Stage);
                            if Stages.Find('-') then begin
                                if (Stages."Modules Registration" = true) and (Stages."Ignore No. Of Units" = false) then begin
                                    CReg.CalcFields(CReg."Units Taken");
                                    if CReg."Exempted Units" <> CReg."Units Taken" then
                                        Error('Units Taken must be equal to the no of modules registered for.');

                                end;
                            end;
                        end;

                        CReg.Posted := true;
                        CReg.Modify;
                    end;


                end else
                    if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Unit Fees") and
                       (StudentCharges.Charge = false) then begin
                        //GenJnl."Bal. Account No.":=GenSetUp."Pre-Payment Account";
                        StudentCharges.CalcFields(StudentCharges."Settlement Type");
                        GenJnl."Bal. Account No." := "Settlement Typ"."Tuition G/L Account";


                        CReg.Reset;
                        CReg.SetCurrentkey(CReg."Reg. Transacton ID");
                        CReg.SetRange(CReg."Reg. Transacton ID", StudentCharges."Reg. Transacton ID");
                        if CReg.Find('-') then begin
                            CReg.Posted := true;
                            CReg.Modify;
                        end;



                    end else

                        if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::Charges) or
                           (StudentCharges.Charge = true) then begin
                            if charges1.Get(StudentCharges.Code) then
                                GenJnl."Bal. Account No." := charges1."G/L Account";
                        end;


                GenJnl.Validate(GenJnl."Bal. Account No.");
                GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                if prog.Get(StudentCharges.Programme) then begin
                    prog.TestField(prog."Department Code");
                    GenJnl."Shortcut Dimension 2 Code" := prog."Department Code";
                end;



                GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                GenJnl."Due Date" := DueDate;
                GenJnl.Validate(GenJnl."Due Date");
                GenJnl.Insert;

                //Distribute Money
                if StudentCharges."Tuition Fee" = true then begin
                    if Stages.Get(StudentCharges.Programme, StudentCharges.Stage) then begin
                        if (Stages."Distribution Full Time (%)" > 0) or (Stages."Distribution Part Time (%)" > 0) then begin
                            Stages.TestField(Stages."Distribution Account");
                            StudentCharges.TestField(StudentCharges.Distribution);
                            if Cust.Get(studRooms.Student) then begin
                                CustPostGroup.Get(Cust."Customer Posting Group");

                                GenJnl.Init;
                                GenJnl."Line No." := GenJnl."Line No." + 10000;
                                GenJnl."Posting Date" := Today;
                                GenJnl."Document No." := StudentCharges."Transacton ID";
                                //GenJnl."Document Type":=GenJnl."Document Type"::Payment;
                                GenJnl.Validate(GenJnl."Document No.");
                                GenJnl."Journal Template Name" := 'SALES';
                                GenJnl."Journal Batch Name" := 'STUD PAY';
                                GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                                //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");
                                GenJnl."Account No." := "Settlement Typ"."Tuition G/L Account";
                                GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                GenJnl.Validate(GenJnl."Account No.");
                                GenJnl.Validate(GenJnl.Amount);
                                GenJnl.Description := 'Fee Distribution';
                                GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                //GenJnl."Bal. Account No.":=Stages."Distribution Account";

                                StudentCharges.CalcFields(StudentCharges."Settlement Type");
                                "Settlement Typ".Get(StudentCharges."Settlement Type");
                                GenJnl."Bal. Account No." := "Settlement Typ"."Tuition G/L Account";

                                GenJnl.Validate(GenJnl."Bal. Account No.");
                                GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                if prog.Get(StudentCharges.Programme) then begin
                                    prog.TestField(prog."Department Code");
                                    GenJnl."Shortcut Dimension 2 Code" := prog."Department Code";
                                end;

                                GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");

                                GenJnl.Insert;

                            end;
                        end;
                    end;
                end else begin
                    //Distribute Charges
                    if StudentCharges.Distribution > 0 then begin
                        StudentCharges.TestField(StudentCharges."Distribution Account");
                        if charges1.Get(StudentCharges.Code) then begin
                            charges1.TestField(charges1."G/L Account");
                            GenJnl.Init;
                            GenJnl."Line No." := GenJnl."Line No." + 10000;
                            GenJnl."Posting Date" := Today;
                            GenJnl."Document No." := StudentCharges."Transacton ID";
                            GenJnl.Validate(GenJnl."Document No.");
                            GenJnl."Journal Template Name" := 'SALES';
                            GenJnl."Journal Batch Name" := 'STUD PAY';
                            GenJnl."Account Type" := GenJnl."account type"::"G/L Account";
                            GenJnl."Account No." := StudentCharges."Distribution Account";
                            GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                            GenJnl.Validate(GenJnl."Account No.");
                            GenJnl.Validate(GenJnl.Amount);
                            GenJnl.Description := 'Fee Distribution';
                            GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                            GenJnl."Bal. Account No." := charges1."G/L Account";
                            GenJnl.Validate(GenJnl."Bal. Account No.");
                            GenJnl."Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";

                            if prog.Get(StudentCharges.Programme) then begin
                                prog.TestField(prog."Department Code");
                                GenJnl."Shortcut Dimension 2 Code" := prog."Department Code";
                            end;
                            GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                            GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                            GenJnl.Insert;

                        end;
                    end;
                end;
                //End Distribution


                StudentCharges.Recognized := true;
                //StudentCharges.MODIFY;
                //.......BY Wanjala
                StudentCharges.Posted := true;
                StudentCharges.Modify;

            //CReg.Posted:=TRUE;
            //CReg.MODIFY;


            //.....END Wanjala

            until StudentCharges.Next = 0;


            /*
            GenJnl.SETRANGE("Journal Template Name",'SALES');
            GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
            IF GenJnl.FIND('-') THEN BEGIN
            REPEAT
            GLPosting.RUN(GenJnl);
            UNTIL GenJnl.NEXT = 0;
            END;


            GenJnl.RESET;
            GenJnl.SETRANGE("Journal Template Name",'SALES');
            GenJnl.SETRANGE("Journal Batch Name",'STUD PAY');
            GenJnl.DELETEALL;
            */

            //Post New
            GenJnl.Reset;
            GenJnl.SetRange("Journal Template Name", 'SALES');
            GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
            if GenJnl.Find('-') then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnl);
            end;

            //Post New


            Cust."Application Method" := Cust."application method"::"Apply to Oldest";
            //Cust.Status:=Cust.Status::Current;
            Cust.Modify;

        end;

        /*
       //BILLING

       StudentPayments.RESET;
       StudentPayments.SETRANGE(StudentPayments."Student No.",student);
       IF StudentPayments.FIND('-') THEN
       StudentPayments.DELETEALL;


       StudentPayments.RESET;
       StudentPayments.SETRANGE(StudentPayments."Student No.",student);
       IF AccPayment=TRUE THEN BEGIN
        IF Cust.GET(student) THEN
        Cust."Application Method":=Cust."Application Method"::"Apply to Oldest";
        Cust. MODIFY;
       END;*/

        Message('The Accommodation charge was generated and posted.');

    end;
}

