Page 50108 "Student  Rooms Transfer"
{
    PageType = Card;
    SourceTable = "Students Hostel Rooms";
    SourceTableView = where(Cleared = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1102760000)
            {
                field(Student; Rec.Student)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student field.';

                    trigger OnValidate()
                    begin
                        HostelLedger.Reset;
                        HostelLedger.SetRange(HostelLedger."Space No", Rec."Space No");
                        if HostelLedger.Find('-') then begin
                            if HostelLedger.Status <> HostelLedger.Status::Vaccant then Error('Please note that you can only select from vacant spaces');
                            Rec."Room No" := HostelLedger."Room No";
                            Rec."Hostel No" := HostelLedger."Hostel No";
                            Rec."Accomodation Fee" := HostelLedger."Room Cost";
                            Rec."Allocation Date" := Today;
                        end;
                        Sem.Reset;
                        Sem.SetRange(Sem."Current Semester", true);
                        if Sem.Find('-') then
                            Rec.Semester := Sem.Code
                        else
                            Error('Please Select the semester');

                        Registered := false;
                        CReg.Reset;
                        CReg.SetRange(CReg."Student No.", Rec.Student);
                        CReg.SetRange(CReg.Semester, Sem.Code);
                        // Creg.SETRANGE(Creg.Posted,TRUE);
                        if CReg.Find('-') then
                            Registered := CReg.Registered;

                        GenSetUp.Get;
                        if GenSetUp."Allow UnPaid Hostel Booking" = false then begin
                            // Check if he has a fee balance
                            if Cust.Get(Rec.Student) then begin
                                Cust.CalcFields(Cust.Balance);
                                if (Cust.Balance > 1) and (Registered = false) then Error('Please Note that you must first clear your balance');
                            end;

                            //Calculate Paid Accomodation Fee
                            PaidAmt := 0;
                            StudentCharges.Reset;
                            StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
                            StudentCharges.SetRange(StudentCharges.Semester, Rec.Semester);
                            StudentCharges.SetRange(StudentCharges.Recognized, true);
                            StudentCharges.SetFilter(StudentCharges.Code, '%1', 'ACC*');
                            if StudentCharges.Find('-') then begin
                                repeat
                                    PaidAmt := PaidAmt + StudentCharges.Amount;
                                until StudentCharges.Next = 0;
                            end;
                            if PaidAmt > Rec."Accomodation Fee" then begin
                                Rec."Over Paid" := true;
                                Rec."Over Paid Amt" := PaidAmt - Rec."Accomodation Fee";
                            end else begin
                                if PaidAmt < Rec."Accomodation Fee" then begin
                                    if ((Cust.Balance * -1) < Rec."Accomodation Fee") and (Registered = false) then // Checking if over paid fee can pay accomodation
                                        Error('Accomodation Fee Paid Can Not Book This Room The Paid Amount is ' + Format((Cust.Balance * -1)))
                                end else begin
                                    Rec."Over Paid" := false;
                                    Rec."Over Paid Amt" := 0;
                                end;
                            end;
                        end;
                    end;
                }
                field(StudentName; Rec."Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student Name field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
            }
            group(CurrDetails)
            {
                Caption = 'Current Block/Room/Space';
                field(HostelNo; Rec."Hostel No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Hostel No field.';
                }
                field(RoomNo; Rec."Room No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Room No field.';
                }
                field(SpaceNo; Rec."Space No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Space No field.';
                }
            }
            group(CurrDetails2)
            {
                Caption = 'New Block/Room/Space';
                field(TransfertoHostelNo; Rec."Transfer to Hostel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer to Hostel No field.';
                }
                field(TransfertoRoomNo; Rec."Transfer to Room No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer to Room No field.';
                }
                field(TransfertoSpaceNo; Rec."Transfer to Space No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer to Space No field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrintAgreement)
            {
                ApplicationArea = Basic;
                Caption = 'Print Agreement';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ToolTip = 'Executes the Print Agreement action.';

                trigger OnAction()
                begin
                    CReg.Reset;
                    CReg.SetFilter(CReg."Student No.", Rec.Student);
                    CReg.SetFilter(CReg.Semester, Rec.Semester);
                    if CReg.Find('-') then
                        Report.Run(70134851, true, true, CReg);
                end;
            }
            action(InventroyItems)
            {
                ApplicationArea = Basic;
                Caption = 'Inventroy Items';
                RunObject = Page "Student hostel Inventory Items";
                RunPageLink = "Student No." = field(Student),
                              "Hostel Block" = field("Hostel No"),
                              "Room Code" = field("Room No"),
                              "Space Code" = field("Space No"),
                              "Academic Year" = field("Academic Year"),
                              Semester = field(Semester);
                Visible = false;
                ToolTip = 'Executes the Inventroy Items action.';
            }
            action(AllocateRoom)
            {
                ApplicationArea = Basic;
                Caption = 'Allocate Room';
                Image = "Action";
                Promoted = true;
                PromotedCategory = New;
                Visible = false;
                ToolTip = 'Executes the Allocate Room action.';

                trigger OnAction()
                begin
                    Clear(settlementType);
                    Cust.Reset;
                    Cust.SetRange(Cust."No.", Rec.Student);
                    if Cust.Find('-') then
                        if Cust."Hostel Black Listed" = false then begin
                            if Confirm('Allocate the Specified Room?', true) = false then Error('Cancelled by user!');
                            Creg1.Reset;
                            Creg1.SetRange(Creg1."Student No.", Rec.Student);
                            Creg1.SetRange(Creg1.Semester, Rec.Semester);
                            Creg1.SetRange(Creg1."Academic Year", Rec."Academic Year");
                            if Creg1.Find('-') then begin
                                // Check if Prog is Special
                                if prog.Get(Creg1.Programme) then begin
                                    if prog."Special Programme" then
                                        settlementType := Settlementtype::"Special Programme"
                                    else
                                        if Creg1."Settlement Type" = 'JAB' then
                                            settlementType := Settlementtype::JAB
                                        else
                                            if Creg1."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                                end;

                            end;
                            "Book Room"(settlementType);
                            // Assign Items
                            hostcard.Reset;
                            hostcard.SetRange(hostcard."Asset No", Rec."Hostel No");
                            if hostcard.Find('-') then begin
                                invItems.Reset;
                                if hostcard.Gender = hostcard.Gender::Male then
                                    invItems.SetFilter(invItems."Hostel Gender", '%1|%2', 1, 2);
                                if invItems.Find('-') then begin
                                    studItemInv.Reset;
                                    studItemInv.SetRange(studItemInv."Student No.", Rec.Student);
                                    studItemInv.SetRange(studItemInv."Academic Year", Rec."Academic Year");
                                    studItemInv.SetRange(studItemInv.Semester, Rec.Semester);
                                    if studItemInv.Find('-') then studItemInv.DeleteAll;
                                    repeat
                                    begin
                                        studItemInv.Init;
                                        studItemInv."Hostel Block" := Rec."Hostel No";
                                        studItemInv."Room Code" := Rec."Room No";
                                        studItemInv."Space Code" := Rec."Space No";
                                        studItemInv."Item Code" := invItems.Item;
                                        studItemInv."Academic Year" := Rec."Academic Year";
                                        studItemInv.Semester := Rec.Semester;
                                        studItemInv.Quantity := invItems."Quantity Per Room";
                                        studItemInv."Fine Amount" := invItems."Fine Amount";
                                        studItemInv.Insert(true);
                                    end;
                                    until invItems.Next = 0;
                                end;
                            end;
                        end else begin
                            Message('The student' + ' ' + Rec.Student + ' ' + 'has been blacklisted!');
                        end;
                end;
            }
            action(ClearRoom)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Room';
                Image = New;
                Promoted = true;
                Visible = false;
                ToolTip = 'Executes the Clear Room action.';

                trigger OnAction()
                begin


                    //IF "Student No" = '' THEN
                    // ERROR('Select a student with a room space firsts.');

                    if Confirm('Are you sure you want to clear this student from the Hostels?', false) = false then
                        exit;

                    Message('Ensure that all the facilities in the room are in a good condition before clearing the room!');
                    clearFromRoom();

                    Message('''' + Rec."Student Name" + ''' has been successfully cleared from ' + Rec."Hostel Name");
                    CurrPage.Update
                end;
            }
            action(BookBatch)
            {
                ApplicationArea = Basic;
                Caption = 'Book Batch';
                Image = PostBatch;
                Promoted = true;
                Visible = false;
                ToolTip = 'Executes the Book Batch action.';

                trigger OnAction()
                begin
                    studRoomBlock.Reset;
                    studRoomBlock.SetFilter(studRoomBlock.Student, '<>%1', '');
                    studRoomBlock.SetFilter(studRoomBlock."Hostel No", '<>%1', '');
                    studRoomBlock.SetFilter(studRoomBlock."Room No", '<>%1', '');
                    studRoomBlock.SetFilter(studRoomBlock."Space No", '<>%1', '');
                    studRoomBlock.SetFilter(studRoomBlock.Semester, '<>%1', '');
                    studRoomBlock.SetFilter(studRoomBlock."Academic Year", '<>%1', '');
                    if studRoomBlock.Find('-') then begin
                        repeat
                            cou := cou + 1;
                            //////////////////////////////////////////////////////////////////////////////////////////////////////////
                            Cust.Reset;
                            Cust.SetRange(Cust."No.", studRoomBlock.Student);
                            if Cust.Find('-') then begin
                            end;

                            StudentHostel.Reset;
                            NoRoom := 0;
                            StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
                            // StudentHostel.SETRANGE(StudentHostel.Billed,FALSE);
                            StudentHostel.SetFilter(StudentHostel."Space No", '<>%1', '');
                            if StudentHostel.Find('-') then begin
                                repeat
                                    // Get the Hostel Name
                                    //StudentHostel.TESTFIELD(StudentHostel.Semester);
                                    // StudentHostel.TESTFIELD(StudentHostel."Academic Year");
                                    // StudentHostel.TESTFIELD(StudentHostel."Space No");
                                    NoRoom := NoRoom + 1;
                                    if NoRoom > 1 then begin
                                        //   ERROR('Please Note That You Can Not Select More Than One Room')
                                    end;
                                    // check if the room is still vacant
                                    Rooms_Spaces.Reset;
                                    Rooms_Spaces.SetRange(Rooms_Spaces."Space Code", StudentHostel."Space No");
                                    Rooms_Spaces.SetRange(Rooms_Spaces."Room Code", StudentHostel."Room No");
                                    Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code", StudentHostel."Hostel No");
                                    if Rooms_Spaces.Find('-') then
                                        if Rooms_Spaces.Status = Rooms_Spaces.Status::Vaccant then begin
                                            ;//ERROR('The selected room is nolonger vacant');

                                            // ----------Check If He has UnCleared Room
                                            StudentHostel.Reset;
                                            StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
                                            StudentHostel.SetRange(StudentHostel.Cleared, false);
                                            if StudentHostel.Find('-') then begin
                                                if StudentHostel.Count > 1 then begin
                                                    // EXIT;// ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
                                                end;
                                            end;
                                            //---Check if The Student Have Paid The Accomodation Fee
                                            StudentCharges.Reset;
                                            StudentCharges.SetRange(StudentCharges."Student No.", studRoomBlock.Student);
                                            StudentCharges.SetRange(StudentCharges.Semester, studRoomBlock.Semester);
                                            StudentCharges.SetRange(StudentCharges.Code, 'ACCOMMODATION');
                                            //StudentCharges.SETRANGE(Posted,TRUE);
                                            /* IF StudentCharges.FIND('-') THEN BEGIN
                                               ChargesRec.SETRANGE(ChargesRec.Code,StudentCharges.Code);
                                               IF ChargesRec.FIND('-') THEN BEGIN
                                                 PaidAmt:=ChargesRec.Amount
                                               END;
                                             END; */

                                            if not StudentCharges.Find('-') then begin
                                                coReg.Reset;
                                                coReg.SetRange(coReg."Student No.", studRoomBlock.Student);
                                                coReg.SetRange(coReg.Semester, studRoomBlock.Semester);
                                                coReg.SetRange(coReg."Academic Year", studRoomBlock."Academic Year");
                                                if coReg.Find('-') then begin
                                                    StudentCharges.Init;
                                                    StudentCharges."Transacton ID" := '';
                                                    StudentCharges.Validate(StudentCharges."Transacton ID");
                                                    StudentCharges."Student No." := coReg."Student No.";
                                                    StudentCharges."Reg. Transacton ID" := coReg."Reg. Transacton ID";
                                                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                                                    StudentCharges.Code := 'ACCOMMODATION';
                                                    StudentCharges.Description := 'Accommodation Fees';
                                                    if Blocks.Get(studRoomBlock."Hostel No") then
                                                        StudentCharges.Amount := Blocks."Cost Per Occupant"
                                                    else
                                                        StudentCharges.Amount := 0;
                                                    StudentCharges.Date := Today;
                                                    StudentCharges.Programme := coReg.Programme;
                                                    StudentCharges.Stage := coReg.Stage;
                                                    StudentCharges.Semester := coReg.Semester;
                                                    //  StudentCharges.INSERT();
                                                end;
                                            end;

                                            if PaidAmt > StudentHostel."Accomodation Fee" then begin
                                                StudentHostel."Over Paid" := true;
                                                StudentHostel."Over Paid Amt" := PaidAmt - StudentHostel."Accomodation Fee";
                                                StudentHostel.Modify;
                                                /*
                                                 END ELSE BEGIN
                                                   IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN

                                                    ERROR('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is '+FORMAT(PaidAmt))
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
                                                Host_Ledger.Gender := studRoomBlock.Gender;
                                                Host_Ledger."Hostel Name" := '';
                                                Host_Ledger.Campus := Cust."Global Dimension 1 Code";
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
                                        end;
                                //  IF StudentHostel."Over Paid" THEN BEGIN
                                //    PostOverPayment();
                                // END;
                                until StudentHostel.Next = 0;
                                // MESSAGE('Room Allocateed Successfully');
                            end;

                        //////////////////////////////////////////////////////////////////////////////////////////////////////////
                        until studRoomBlock.Next = 0;
                    end;

                    Message(Format(cou));

                end;
            }
            action(PrintInvoice)
            {
                ApplicationArea = Basic;
                Caption = 'Print Invoice';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;
                ToolTip = 'Executes the Print Invoice action.';

                trigger OnAction()
                begin
                    allocations.Reset;
                    allocations.SetRange(allocations.Student, Rec.Student);
                    allocations.SetRange(allocations."Hostel No", Rec."Hostel No");
                    allocations.SetRange(allocations."Room No", Rec."Room No");
                    allocations.SetRange(allocations."Space No", Rec."Space No");
                    allocations.SetRange(allocations."Academic Year", Rec."Academic Year");
                    allocations.SetRange(allocations.Semester, Rec.Semester);
                    if allocations.Find('-') then
                        Report.Run(70135094, true, false, allocations)
                end;
            }
            action(PostTransfer)
            {
                ApplicationArea = Basic;
                Caption = 'Post Transfer';
                Image = TransferFunds;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Transfer action.';

                trigger OnAction()
                begin
                    Rec.TestField(Cleared, false);
                    Rec.TestField("Transfer to Hostel No");
                    Rec.TestField("Transfer to Room No");
                    Rec.TestField("Transfer to Space No");
                    Rec.TestField("Hostel No");
                    Rec.TestField("Room No");
                    Rec.TestField("Space No");

                    if ((Rec."Transfer to Hostel No" = Rec."Hostel No") and
                   (Rec."Transfer to Room No" = Rec."Room No")
                   ) then
                        Error('The two rooms are the same');

                    CourseReg.Reset;
                    CourseReg.SetRange(CourseReg."Student No.", Rec.Student);
                    //CourseReg.SETRANGE(CourseReg.Semester,Semester);
                    //CourseReg.SETRANGE(CourseReg."Academic Year","Academic Year");
                    if CourseReg.Find('-') then begin
                        prog.Reset;
                        if prog.Get(CourseReg.Programme) then begin
                        end;
                    end else
                        Error('The Student is not registered for the current Semester.');
                    // Check if the room costs are equal
                    rooms1.Reset;
                    rooms1.SetRange(rooms1."Hostel Code", Rec."Hostel No");
                    rooms1.SetRange(rooms1."Room Code", Rec."Room No");
                    if rooms1.Find('-') then begin

                        rooms2.Reset;
                        rooms2.SetRange(rooms2."Hostel Code", Rec."Transfer to Hostel No");
                        rooms2.SetRange(rooms2."Room Code", Rec."Transfer to Room No");
                        if rooms2.Find('-') then begin
                            if not (prog."Special Programme") then begin
                                if CourseReg."Settlement Type" = 'SCHOOL BASED' then begin
                                    if not (rooms1."JAB Fees" = rooms2."JAB Fees") then Error('Fees for the destination room must be equal to ' + Format(rooms1."JAB Fees"));
                                end else
                                    if CourseReg."Settlement Type" = 'REGULAR' then begin
                                        if not (rooms1."SSP Fees" = rooms2."SSP Fees") then Error('Fees for the destination room must be equat to ' + Format(rooms1."SSP Fees"));
                                    end;
                            end;// end if not special Programme
                        end;
                    end;

                    if Confirm('Tranfer student from ' + Rec."Space No" + ' to ' + Rec."Transfer to Space No", false) = false then Error('Transfer cancelled');
                    // Clear Existing Room
                    clearFromRoom();
                    // Allocate a new room without Posting charges
                    Creg1.Reset;
                    Creg1.SetRange(Creg1."Student No.", Rec.Student);
                    Creg1.SetRange(Creg1.Semester, Rec.Semester);
                    //  Creg1.SETRANGE(Creg1."Academic Year","Academic Year");
                    if Creg1.Find('-') then begin
                        // Check if Prog is Special
                        if prog.Get(Creg1.Programme) then begin
                            if prog."Special Programme" then
                                settlementType := Settlementtype::"Special Programme"
                            else
                                if Creg1."Settlement Type" = 'JAB' then
                                    settlementType := Settlementtype::JAB
                                else
                                    if Creg1."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                        end;

                    end;

                    "Book Room"(settlementType);
                    // Assign Items
                    hostcard.Reset;
                    hostcard.SetRange(hostcard."Asset No", Rec."Hostel No");
                    if hostcard.Find('-') then begin
                        invItems.Reset;
                        if hostcard.Gender = hostcard.Gender::Male then
                            invItems.SetFilter(invItems."Hostel Gender", '%1|%2', 1, 2);
                        if invItems.Find('-') then begin
                            studItemInv.Reset;
                            studItemInv.SetRange(studItemInv."Student No.", Rec.Student);
                            // studItemInv.SETRANGE(studItemInv."Academic Year","Academic Year");
                            studItemInv.SetRange(studItemInv.Semester, Rec.Semester);
                            if studItemInv.Find('-') then studItemInv.DeleteAll;
                            repeat
                            begin
                                studItemInv.Init;
                                studItemInv."Hostel Block" := Rec."Transfer to Hostel No";
                                studItemInv."Room Code" := Rec."Transfer to Room No";
                                studItemInv."Space Code" := Rec."Transfer to Space No";
                                studItemInv."Item Code" := invItems.Item;
                                studItemInv."Academic Year" := Rec."Academic Year";
                                studItemInv.Semester := Rec.Semester;
                                studItemInv.Quantity := invItems."Quantity Per Room";
                                studItemInv."Fine Amount" := invItems."Fine Amount";
                                studItemInv.Insert(true);
                            end;
                            until invItems.Next = 0;
                        end;
                    end;



                    Rec."Transfed from Hostel No" := Rec."Hostel No";
                    Rec."Transfed from Room No" := Rec."Room No";
                    Rec."Transfed from Space No" := Rec."Space No";
                    //"Hostel No":="Transfer to Hostel No"  ;
                    //"Room No":="Transfer to Room No";
                    //"Space No":="Transfer to Space No";
                    //MODIFY;
                    Message('Student successfully transffered');

                    Rec."Transfered By" := UserId;
                    Rec."Time Transfered" := Time;
                    Rec."Date Transfered" := Today;
                    Rec.Transfered := true;
                    Rec.Modify;
                end;
            }
        }
    }

    var
        charges1: Record Charge;
        cou: Integer;
        studRoomBlock: Record "Students Hostel Rooms";
        Blocks: Record "Hostel Card";
        coReg: Record "Course Registration";
        HostelLedger: Record "Hostel Ledger";
        Sem: Record Semesters;
        Registered: Boolean;
        acadYear: Record "Academic Year";
        semz: Record Semesters;
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        PaidAmt: Decimal;
        NoRoom: Integer;
        CourseReg: Record "Course Registration";
        CReg: Record "Course Registration";
        Cust: Record Customer;
        StudentHostel: Record "Students Hostel Rooms";
        StudentCharges: Record "Student Charges";
        GenSetUp: Record "General Set-Up";
        Rooms_Spaces: Record "Room Spaces";
        Hostel_Rooms: Record "Hostel Block Rooms";
        Host_Ledger: Record "Hostel Ledger";
        counts: Integer;
        hostcard: Record "Hostel Card";
        studItemInv: Record "Student hostel Inventory Items";
        invItems: Record "Hostel Inventory";
        settlementType: Option " ",JAB,SSP,"Special Programme";
        Creg1: Record "Course Registration";
        prog: Record Programme;
        allocations: Record "Students Hostel Rooms";
        rooms1: Record "Hostel Block Rooms";
        rooms2: Record "Hostel Block Rooms";

    procedure PostOverPayment()
    begin
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'PAYMENTs');
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", 'CHARGES');
        if GenJnlLine.Find('-') then begin
            GenJnlLine.DeleteAll
        end;

        StudentHostel.Reset;
        StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
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
                GenJnlLine."Account No." := Cust."No.";
                GenJnlLine.Validate(GenJnlLine."Account No.");
                GenJnlLine."Posting Date" := Today;
                GenJnlLine."Document Type" := GenJnlLine."document type"::Payment;
                GenJnlLine."Document No." := StudentHostel."Space No" + ' ' + StudentHostel."Room No";
                //GenJnlLine."External Document No.":="Cheque No";
                GenJnlLine.Amount := -StudentHostel."Over Paid Amt";
                GenJnlLine.Validate(GenJnlLine.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '300202';
                // GenJnlLine.Description:=Name;
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

    procedure clearFromRoom()
    var
        Rooms: Record "Hostel Block Rooms";
        spaces: Record "Room Spaces";
        hostLedger: Record "Hostel Ledger";
        HostRooms: Record "Students Hostel Rooms";
    begin
        hostLedger.Reset;
        // hostLedger.SETRANGE(hostLedger."Hostel No","Hostel No");
        hostLedger.SetRange(hostLedger."Room No", Rec."Room No");
        hostLedger.SetRange(hostLedger."Space No", Rec."Space No");
        if hostLedger.Find('-') then begin
            repeat
            begin
                HostRooms.Reset;
                HostRooms.SetRange(HostRooms.Student, hostLedger."Student No");
                //HostRooms.SETRANGE(HostRooms."Academic Year",hostLedger."Academic Year");
                HostRooms.SetRange(HostRooms.Semester, hostLedger.Semester);
                HostRooms.SetRange(HostRooms."Hostel No", Rec."Hostel No");
                HostRooms.SetRange(HostRooms."Room No", hostLedger."Room No");
                HostRooms.SetRange(HostRooms."Space No", hostLedger."Space No");
                HostRooms.SetRange(HostRooms.Cleared, false);
                if HostRooms.Find('-') then begin
                    HostRooms.Cleared := true;
                    HostRooms."Clearance Date" := Today;
                    HostRooms.Modify;
                end;
                hostLedger.Delete;
            end;
            until hostLedger.Next = 0;
        end;


        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code", Rec."Hostel No");
        spaces.SetRange(spaces."Room Code", Rec."Room No");
        spaces.SetRange(spaces."Space Code", Rec."Space No");
        if spaces.Find('-') then begin
            repeat
            begin
                spaces.Status := spaces.Status::Vaccant;
                spaces."Student No" := '';
                spaces."Receipt No" := '';
                spaces."Black List reason" := '';
                spaces.Modify;
            end;
            until spaces.Next = 0;
        end;

        Rooms.Reset;
        Rooms.SetRange(Rooms."Hostel Code", Rec."Hostel No");
        Rooms.SetRange(Rooms."Room Code", Rec."Room No");
        if Rooms.Find('-') then begin
            repeat
                Rooms.Validate(Rooms.Status);
            until Rooms.Next = 0;
        end;
    end;

    procedure "Book Room"(var settle_m: Option " ",JAB,SSP,"Special Programme")
    var
        rooms: Record "Hostel Block Rooms";
        billAmount: Decimal;
        counted: Integer;
    begin
        // -- Create a new allocation
        StudentHostel.Reset;
        StudentHostel.SetFilter(StudentHostel."Line No", '<>%1', 0);
        StudentHostel.SetCurrentkey(StudentHostel."Line No");
        if StudentHostel.Find('+') then
            counted := StudentHostel."Line No"
        else
            counted := 1000;
        // --------Check If More Than One Room Has Been Selected
        counted := counted + 1;
        StudentHostel.Init;
        StudentHostel."Line No" := counted;
        StudentHostel.Student := Rec.Student;
        StudentHostel."Space No" := Rec."Transfer to Space No";
        StudentHostel."Room No" := Rec."Transfer to Room No";
        StudentHostel."Hostel No" := Rec."Transfer to Hostel No";
        StudentHostel."Accomodation Fee" := Rec."Accomodation Fee";
        StudentHostel."Allocation Date" := Today;
        StudentHostel.Charges := Rec.Charges;
        StudentHostel.Billed := Rec.Billed;
        StudentHostel."Billed Date" := Rec."Billed Date";
        StudentHostel.Semester := Rec.Semester;
        StudentHostel."Academic Year" := Rec."Academic Year";
        StudentHostel.Allocated := false;
        StudentHostel."Transfed from Hostel No" := Rec."Hostel No";
        StudentHostel."Transfed from Room No" := Rec."Room No";
        StudentHostel."Transfed from Space No" := Rec."Space No";
        StudentHostel.Gender := Rec.Gender;
        StudentHostel.Insert;

        Clear(billAmount);
        rooms.Reset;
        rooms.SetRange(rooms."Hostel Code", Rec."Transfer to Hostel No");
        rooms.SetRange(rooms."Room Code", Rec."Transfer to Room No");
        if rooms.Find('-') then begin
            if settle_m = Settle_m::"Special Programme" then
                billAmount := rooms."Special Programme"
            else
                if settle_m = Settle_m::JAB then
                    billAmount := rooms."JAB Fees"
                else
                    if settle_m = Settle_m::SSP then
                        billAmount := rooms."SSP Fees"

        end;
        Cust.Reset;
        Cust.SetRange(Cust."No.", Rec.Student);
        if Cust.Find('-') then begin
        end;

        StudentHostel.Reset;
        NoRoom := 0;
        StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
        StudentHostel.SetFilter(StudentHostel.Allocated, '=%1', false);
        StudentHostel.SetRange(StudentHostel.Cleared, false);
        StudentHostel.SetFilter(StudentHostel."Space No", '<>%1', '');
        if StudentHostel.Find('-') then begin
            repeat
                // Get the Hostel Name
                StudentHostel.TestField(StudentHostel.Semester);
                // StudentHostel.TESTFIELD(StudentHostel."Academic Year");
                StudentHostel.TestField(StudentHostel."Space No");
                NoRoom := NoRoom + 1;
                if NoRoom > 1 then begin
                    //ERROR('Please Note That You Can Not Select More Than One Room')
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
                StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
                StudentHostel.SetRange(StudentHostel.Cleared, false);
                if StudentHostel.Find('-') then begin
                    if StudentHostel.Count > 1 then begin
                        //  ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
                    end;
                end;
                //---Check if The Student Have Paid The Accomodation Fee
                charges1.Reset;
                charges1.SetRange(charges1.Hostel, true);
                if charges1.Find('-') then begin
                end else
                    Error('Accommodation not setup.');

                StudentCharges.Reset;
                StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
                StudentCharges.SetRange(StudentCharges.Semester, Rec.Semester);
                StudentCharges.SetRange(StudentCharges.Code, charges1.Code);
                //StudentCharges.SETRANGE(Posted,TRUE);
                /* IF StudentCharges.FIND('-') THEN BEGIN
                   ChargesRec.SETRANGE(ChargesRec.Code,StudentCharges.Code);
                   IF ChargesRec.FIND('-') THEN BEGIN
                     PaidAmt:=ChargesRec.Amount
                   END;
                 END; */
                if Blocks.Get(Rec."Hostel No") then begin
                end;

                if not StudentCharges.Find('-') then begin
                    coReg.Reset;
                    coReg.SetRange(coReg."Student No.", Rec.Student);
                    coReg.SetRange(coReg.Semester, Rec.Semester);
                    //coReg.SETRANGE(coReg."Academic Year","Academic Year");
                    if coReg.Find('-') then begin
                        StudentCharges.Init;
                        StudentCharges."Transacton ID" := '';
                        StudentCharges.Validate(StudentCharges."Transacton ID");
                        StudentCharges."Student No." := coReg."Student No.";
                        StudentCharges."Reg. Transacton ID" := coReg."Reg. Transacton ID";
                        StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                        StudentCharges.Code := charges1.Code;
                        StudentCharges.Description := 'Accommodation Fees';
                        // IF Blocks.GET("Hostel No") THEN
                        // StudentCharges.Amount:=Blocks."Cost Per Occupant"
                        // ELSE
                        StudentCharges.Amount := billAmount;
                        StudentCharges.Date := Today;
                        StudentCharges.Programme := coReg.Programme;
                        StudentCharges.Stage := coReg.Stage;
                        StudentCharges.Semester := coReg.Semester;
                        //StudentCharges.INSERT();
                    end;
                end;

                if PaidAmt > StudentHostel."Accomodation Fee" then begin
                    StudentHostel."Over Paid" := true;
                    StudentHostel."Over Paid Amt" := PaidAmt - StudentHostel."Accomodation Fee";
                    StudentHostel.Modify;
                    /*
                     END ELSE BEGIN
                       IF PaidAmt<>StudentHostel."Accomodation Fee" THEN BEGIN

                        ERROR('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is '+FORMAT(PaidAmt))
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
                    //IF NOT Host_Ledger.GET(StudentHostel."Space No",StudentHostel."Room No",StudentHostel."Hostel No") THEN BEGIN
                    Host_Ledger.Init;
                    Host_Ledger."Space No" := StudentHostel."Space No";
                    Host_Ledger."Room No" := StudentHostel."Room No";
                    Host_Ledger."Hostel No" := StudentHostel."Hostel No";
                    Host_Ledger.No := counts;
                    Host_Ledger.Status := Host_Ledger.Status::"Fully Occupied";
                    Host_Ledger."Room Cost" := Rec.Charges;
                    Host_Ledger."Student No" := StudentHostel.Student;
                    Host_Ledger."Receipt No" := '';
                    Host_Ledger.Semester := StudentHostel.Semester;
                    Host_Ledger.Gender := Rec.Gender;
                    Host_Ledger."Hostel Name" := '';
                    Host_Ledger.Campus := Cust."Global Dimension 1 Code";
                    Host_Ledger."Academic Year" := StudentHostel."Academic Year";
                    Host_Ledger.Insert;
                    //END;

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
            // MESSAGE('Room Allocateed Successfully');
        end;

    end;
}

