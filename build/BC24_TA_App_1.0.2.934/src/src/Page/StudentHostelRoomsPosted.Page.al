Page 50106 "Student Hostel Rooms Posted"
{
    PageType = List;
    SourceTable = "Students Hostel Rooms";
    SourceTableView = where(Allocated = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
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
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(HostelNo; Rec."Hostel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel No field.';
                }
                field(RoomNo; Rec."Room No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room No field.';
                }
                field(SpaceNo; Rec."Space No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Space No field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Charges; Rec.Charges)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Charges field.';
                }
                field(AllocationDate; Rec."Allocation Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Allocation Date field.';
                }
                field(AcademicYear; Rec."Academic Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Cleared; Rec.Cleared)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cleared field.';
                }
                field(Allocated; Rec.Allocated)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Allocated field.';
                }
                field(HostelName; Rec."Hostel Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Hostel Name field.';
                }
                field(StudentName; Rec."Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student Name field.';
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
                Image = InventoryJournal;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Student hostel Inventory Items";
                RunPageLink = "Student No." = field(Student),
                              "Hostel Block" = field("Hostel No"),
                              "Room Code" = field("Room No"),
                              "Space Code" = field("Space No"),
                              "Academic Year" = field("Academic Year"),
                              Semester = field(Semester);
                ToolTip = 'Executes the Inventroy Items action.';
            }
            group(Functions)
            {
                group(Function_Buttons)
                {
                    Caption = 'Operations';
                    Image = Transactions;
                    action(Allocate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Allocate Room';
                        Image = "Action";
                        Promoted = true;
                        PromotedCategory = New;
                        PromotedIsBig = true;
                        Visible = false;
                        ToolTip = 'Executes the Allocate Room action.';

                        trigger OnAction()
                        begin
                            //Check the Policy
                            Rec.TestField(Allocated, false);
                            if Cust.Get(Rec.Student) then begin
                                Cust.CalcFields(Cust.Balance);

                                semz.Reset;
                                semz.SetRange(semz."Current Semester", true);
                                CReg.Reset;
                                CReg.SetRange(CReg."Student No.", Cust."No.");
                                if semz.Find('-') then
                                    CReg.SetRange(CReg.Semester, semz.Code);
                                CReg.SetRange(CReg.Posted, true);
                                if CReg.Find('-') then begin  //2
                                    CReg.CalcFields(CReg."Total Billed");
                                    // IF CReg."Total Billed"=0 THEN ERROR('Fees payment policy error --Billing');

                                    if CReg."Total Billed" <> 0 then begin  // 1
                                                                            //frankmur by  onder of    frankur  finance   reg  2017  secord  sem IF Cust.Balance>(CReg."Total Billed"/2) THEN ERROR('Fees payment Accommodation policy error--Balance');
                                        allocations.Reset;
                                        allocations.SetRange(allocations.Student, Cust."No.");
                                        allocations.SetRange(allocations."Hostel No", Cust."Hostel No.");
                                        allocations.SetRange(allocations."Room No", Cust."Room Code");
                                        allocations.SetRange(allocations."Space No", Cust."Space Booked");
                                        //allocations.SETRANGE(allocations."Academic Year","Academic Year");
                                        // allocations.SetRange(allocations.Semester, Cust.Semester);
                                        // IF Allocations.FIND('-') THEN
                                        // REPORT.RUN(70134974,TRUE,FALSE,Allocations);
                                    end else begin  //1
                                                    // ERROR('Fees payment Accommodation policy error --Billing');
                                    end; //1
                                end else begin //2
                                               //ERROR('Fees payment Accommodation policy error --Registration');
                                end; //2
                            end;

                            Clear(settlementType);
                            Cust.Reset;
                            Cust.SetRange(Cust."No.", Rec.Student);
                            if Cust.Find('-') then
                                if Cust."Hostel Black Listed" = false then begin
                                    if Confirm('Allocate the Specified Room?', true) = false then Error('Cancelled by user!');
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
                                                if Creg1."Settlement Type" = 'KUCCPS' then
                                                    settlementType := Settlementtype::KUCCPS
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
                                                    //frank
                                                    //---Check if The Student Have Paid The Accomodation Fee
                                                    StudentCharges.Reset;
                                                    StudentCharges.SetRange(StudentCharges."Student No.", studRoomBlock.Student);
                                                    StudentCharges.SetRange(StudentCharges.Semester, studRoomBlock.Semester);
                                                    StudentCharges.SetRange(StudentCharges.Code, 'ACCOMMODATION');
                                                    //StudentCharges.SETRANGE(Posted,TRUE);
                                                    //frankline
                                                    if StudentCharges.Find('-') then begin
                                                        ChargesRec.SetRange(ChargesRec.Code, StudentCharges.Code);
                                                        if ChargesRec.Find('-') then begin
                                                            PaidAmt := ChargesRec.Amount
                                                        end;
                                                    end;
                                                    //frankline

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
                                                            StudentCharges.Insert();
                                                        end;
                                                    end;

                                                    if PaidAmt > StudentHostel."Accomodation Fee" then begin
                                                        StudentHostel."Over Paid" := true;
                                                        StudentHostel."Over Paid Amt" := PaidAmt - StudentHostel."Accomodation Fee";
                                                        StudentHostel.Modify;

                                                    end else begin
                                                        if PaidAmt <> StudentHostel."Accomodation Fee" then begin

                                                            Error('Accomodation Fee Paid Can Not Allocate This Room The Paid Amount is ' + Format(PaidAmt))
                                                        end;

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
                                                        //FRANK
                                                        if StudentHostel.Allocated = true then begin
                                                            StudentHostel.Reset;
                                                            StudentHostel.SetRange(StudentHostel.Student, Boks.No);
                                                            if StudentHostel.Find('-') then begin
                                                                Boks."Given  Room" := true;
                                                                Boks."Room No" := StudentHostel."Space No";
                                                                Boks."Billed Date" := Today;
                                                                Boks."Total Amount" := StudentHostel.Charges;
                                                                Boks.Modify;
                                                                Message('STUDENT ON BOOKING  ROOM MODIFIED');
                                                            end;
                                                        end
                                                    end;
                                                end;

                                        //FRANK
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
                    action("Print Invoice")
                    {
                        ApplicationArea = Basic;
                        Image = Invoice;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Print Invoice action.';

                        trigger OnAction()
                        begin
                            /* IF Cust.GET(Student) THEN BEGIN
                             WITH Cust DO BEGIN
                               CALCFIELDS(Balance);
                             CReg.RESET;
                             CReg.SETRANGE(CReg."Student No.",Student);
                             CReg.SETRANGE(CReg.Semester,Semester);
                             CReg.SETRANGE(CReg.Posted,TRUE);
                             IF CReg.FIND('-') THEN BEGIN
                             CReg.CALCFIELDS(CReg."Total Billed");
                             IF CReg."Total Billed"<>0 THEN BEGIN
                             IF Balance>(CReg."Total Billed"/2) THEN ERROR('Fees payment Accommodation policy error--Balance');    */
                            allocations.Reset;
                            allocations.SetRange(allocations.Student, Rec.Student);
                            allocations.SetRange(allocations."Hostel No", Rec."Hostel No");
                            allocations.SetRange(allocations."Room No", Rec."Room No");
                            allocations.SetRange(allocations."Space No", Rec."Space No");
                            //  allocations.SETRANGE(allocations."Academic Year","Academic Year");
                            allocations.SetRange(allocations.Semester, Rec.Semester);
                            allocations.SetRange(Billed, true);
                            if allocations.Find('-') then
                                Report.Run(70135094, true, false, allocations);
                            /* END ELSE BEGIN
                             ERROR('Fees payment Accommodation policy error --Billing');
                             END;
                             END ELSE BEGIN
                             ERROR('Fees payment Accommodation policy error --Registration');
                             END;
                             END;
                             END;*/

                        end;
                    }
                    action(Rev_Allocation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reverse Allocarion';
                        Image = ReverseLines;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Reverse Allocarion action.';

                        trigger OnAction()
                        begin
                            Rec.TestField(Cleared, false);
                            Rec.TestField(Allocated, true);
                            if Confirm('Reverse allocation?', false) = false then Error('Cancelled!');
                            // Clear Room
                            clearFromRoom_Reversal();
                            // Post charge Reversal
                            postChargeReversal();
                        end;
                    }
                    action(trans)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Transfer Student';
                        Image = TransferOrder;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Transfer Student action.';

                        trigger OnAction()
                        begin
                            if ((Rec.Allocated = false) or (Rec.Cleared = true)) then Error('You can only transfer posted allocations');
                            hostStus.Reset;
                            hostStus.SetRange(hostStus."Hostel No", Rec."Hostel No");
                            hostStus.SetRange(hostStus."Room No", Rec."Room No");
                            hostStus.SetRange(hostStus."Space No", Rec."Space No");
                            hostStus.SetRange(hostStus.Student, Rec.Student);
                            hostStus.SetRange(hostStus.Semester, Rec.Semester);
                            hostStus.SetRange(hostStus."Academic Year", Rec."Academic Year");
                            if hostStus.Find('-') then begin
                                Page.Run(70134932, hostStus);
                            end;
                        end;
                    }
                    action(Switch_Rooms)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Switch Rooms';
                        Image = TransferReceipt;
                        Promoted = true;
                        PromotedIsBig = true;
                        ToolTip = 'Executes the Switch Rooms action.';

                        trigger OnAction()
                        begin
                            if ((Rec.Allocated = false) or (Rec.Cleared = true)) then Error('You can only Swap/Switch posted allocations');
                            hostStus.Reset;
                            hostStus.SetRange(hostStus."Hostel No", Rec."Hostel No");
                            hostStus.SetRange(hostStus."Room No", Rec."Room No");
                            hostStus.SetRange(hostStus."Space No", Rec."Space No");
                            hostStus.SetRange(hostStus.Student, Rec.Student);
                            hostStus.SetRange(hostStus.Semester, Rec.Semester);
                            //hostStus.SETRANGE(hostStus."Academic Year","Academic Year");
                            if hostStus.Find('-') then begin
                                Page.Run(70134933, hostStus);
                            end;
                        end;
                    }
                    action(ClearRoom)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Clear Room';
                        Image = New;
                        Promoted = true;
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
                }
            }
        }
    }

    var
        AccPayment: Boolean;
        hostStus: Record "Students Hostel Rooms";
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
        GenJnl: Record "Gen. Journal Line";
        Stages: Record "Programme Stages";
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        ChargesRec: Record Charge;
        PaidAmt: Decimal;
        NoRoom: Integer;
        NoSeries: Record "No. Series Line";
        CReg: Record "Course Registration";
        LastNo: Code[20];
        Cust: Record Customer;
        CustPostGroup: Record "Customer Posting Group";
        DueDate: Date;
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
        settlementType: Option " ",KUCCPS,SSP,"Special Programme";
        Creg1: Record "Course Registration";
        prog: Record Programme;
        allocations: Record "Students Hostel Rooms";
        "Settlement TypeR": Record "Settlement Type";
        Boks: Record "Hostel Booking Agents";

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
    begin
        hostLedger.Reset;
        hostLedger.SetRange(hostLedger."Hostel No", Rec."Hostel No");
        hostLedger.SetRange(hostLedger."Room No", Rec."Room No");
        hostLedger.SetRange(hostLedger."Space No", Rec."Space No");
        if hostLedger.Find('-') then begin
            hostLedger.DeleteAll;
        end;


        studRoomBlock.Reset;
        studRoomBlock.SetRange(studRoomBlock.Student, Rec.Student);
        studRoomBlock.SetRange(studRoomBlock."Space No", Rec."Space No");
        if studRoomBlock.Find('-') then begin
            studRoomBlock.Cleared := true;
            studRoomBlock."Clearance Date" := Today;
            studRoomBlock."Eviction Code" := 'CLEARED';
            studRoomBlock."Hostel Assigned" := false;
            studRoomBlock.Allocated := false;
            studRoomBlock.Modify;
        end;



        spaces.Reset;
        spaces.SetRange(spaces."Hostel Code", Rec."Hostel No");
        spaces.SetRange(spaces."Room Code", Rec."Room No");
        spaces.SetRange(spaces."Space Code", Rec."Space No");
        if spaces.Find('-') then begin
            spaces.Status := spaces.Status::Vaccant;
            spaces."Student No" := '';
            spaces."Receipt No" := '';
            spaces."Black List reason" := '';
            spaces.Modify;
        end;

        Rooms.Reset;
        Rooms.SetRange(Rooms."Hostel Code", Rec."Hostel No");
        Rooms.SetRange(Rooms."Room Code", Rec."Room No");
        if Rooms.Find('-') then begin

            Rooms.Validate(Rooms.Status);

        end;
    end;

    procedure "Book Room"(var settle_m: Option " ",JAB,SSP,"Special Programme")
    var
        rooms: Record "Hostel Block Rooms";
        billAmount: Decimal;
    begin
        // --------Check If More Than One Room Has Been Selected
        Clear(billAmount);
        rooms.Reset;
        rooms.SetRange(rooms."Hostel Code", Rec."Hostel No");
        rooms.SetRange(rooms."Room Code", Rec."Room No");
        if rooms.Find('-') then begin
            if settle_m = Settle_m::"Special Programme" then
                billAmount := rooms."Room Cost"
            else
                if settle_m = Settle_m::JAB then
                    billAmount := rooms."Room Cost"
                else
                    if settle_m = Settle_m::SSP then
                        billAmount := rooms."Room Cost"

        end;
        Cust.Reset;
        Cust.SetRange(Cust."No.", Rec.Student);
        if Cust.Find('-') then begin
        end;

        StudentHostel.Reset;
        NoRoom := 0;
        StudentHostel.SetRange(StudentHostel.Student, Cust."No.");
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
                    Error('Please Note That You Can Not Select More Than One Room')
                end;
                // check if the room is still vacant
                if StudentHostel."Space No" = '' then begin
                    Rooms_Spaces.Reset;
                    Rooms_Spaces.SetRange(Rooms_Spaces."Space Code", StudentHostel."Space No");
                    Rooms_Spaces.SetRange(Rooms_Spaces."Room Code", StudentHostel."Room No");
                    Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code", StudentHostel."Hostel No");
                    if Rooms_Spaces.Find('-') then
                        if Rooms_Spaces.Status <> Rooms_Spaces.Status::Vaccant then
                            Error('The selected room is nolonger vacant.' + StudentHostel."Space No" + '-' + StudentHostel."Room No" + '-'
+ StudentHostel."Hostel No");
                end;
                /*
                 // ----------Check If He has UnCleared Room
                StudentHostel.RESET;
                StudentHostel.SETRANGE(StudentHostel.Student,Cust."No.");
                StudentHostel.SETRANGE(StudentHostel.Cleared,FALSE);
                IF StudentHostel.FIND('-') THEN BEGIN
                   IF StudentHostel.COUNT>1 THEN BEGIN
                     ERROR('Please Note That You Must First Clear Your Old Rooms Before You Allocate Another Room')
                   END;
                END;
                */
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
                        StudentCharges.Insert();
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
                    Host_Ledger."Space No" := Rec."Space No";
                    Host_Ledger."Room No" := Rec."Room No";
                    Host_Ledger."Hostel No" := Rec."Hostel No";
                    Host_Ledger.No := counts;
                    Host_Ledger.Status := Host_Ledger.Status::"Fully Occupied";
                    Host_Ledger."Room Cost" := StudentHostel.Charges;
                    Host_Ledger."Student No" := StudentHostel.Student;
                    Host_Ledger."Receipt No" := '';
                    Host_Ledger.Semester := StudentHostel.Semester;
                    Host_Ledger.Gender := Rec.Gender;
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
                //  IF StudentHostel."Over Paid" THEN BEGIN
                //    PostOverPayment();
                if StudentHostel.Allocated = true then begin
                    Boks.Reset;
                    Boks.SetRange(Boks.No, StudentHostel.Student);
                    if Boks.Find('-') then begin
                        Boks."Given  Room" := true;
                        Boks."Room No" := StudentHostel."Room No";
                        Boks."Total Amount" := StudentHostel.Charges;
                        Boks."Billed Date" := Today;
                        Boks.Modify;
                    end;
                end;

            until StudentHostel.Next = 0;
            //frankmur
            Message('Room Allocateed Successfully');
        end;

        postCharge();

    end;

    local procedure postCharge()
    begin
        //BILLING
        charges1.Reset;
        charges1.SetRange(charges1.Hostel, true);
        if not charges1.Find('-') then begin
            Error('The charges Setup does not have an item tagged as Hostel.');
        end;

        AccPayment := false;
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
        StudentCharges.SetRange(StudentCharges.Recognized, false);
        StudentCharges.SetFilter(StudentCharges.Code, '=%1', charges1.Code);
        if not StudentCharges.Find('-') then begin //3
                                                   // The charge does not exist. Created it, but check first if it exists as unrecognized
            StudentCharges.Reset;
            StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
            //StudentCharges.SETRANGE(StudentCharges.Recognized,FALSE);
            StudentCharges.SetFilter(StudentCharges.Code, '=%1', charges1.Code);
            if not StudentCharges.Find('-') then begin //4
                                                       // Does not exist hence just create
                CReg.Reset;
                CReg.SetRange(CReg."Student No.", Rec.Student);
                CReg.SetRange(CReg.Semester, Rec.Semester);
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
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges."Student No." := Rec.Student;
                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                    StudentCharges."Reg. Transacton ID" := CReg."Reg. Transacton ID";
                    StudentCharges.Description := 'Hostel Charges ' + Rec."Space No";
                    StudentCharges.Amount := Rec.Charges;
                    StudentCharges.Date := Today;
                    StudentCharges.Code := charges1.Code;
                    StudentCharges.Charge := true;
                    StudentCharges.Insert(true);
                    Rec.Billed := true;
                    Rec."Billed Date" := Today;
                    Rec.Modify;
                end; //5

            end else begin//4
                          // Charge Exists, Delete from the charges then create a new one
                StudentCharges.Delete;

                CReg.Reset;
                CReg.SetRange(CReg."Student No.", Rec.Student);
                CReg.SetRange(CReg.Semester, Rec.Semester);
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
                    StudentCharges.Validate(StudentCharges."Transacton ID");
                    StudentCharges."Student No." := Rec.Student;
                    StudentCharges."Transaction Type" := StudentCharges."transaction type"::Charges;
                    StudentCharges."Reg. Transacton ID" := CReg."Reg. Transacton ID";
                    StudentCharges.Description := 'Hostel Charges ' + Rec."Space No";
                    StudentCharges.Amount := Rec.Charges;
                    StudentCharges.Date := Today;
                    StudentCharges.Code := charges1.Code;
                    StudentCharges.Charge := true;
                    StudentCharges.Insert(true);
                    // Billed:=TRUE;
                    // "Billed Date":=TODAY;
                    // MODIFY;
                end; //5
            end;//4

        end; //3


        //SettlementType1:='';
        CReg.Reset;
        CReg.SetRange(CReg."Student No.", Rec.Student);
        CReg.SetRange(CReg.Semester, Rec.Semester);
        if CReg.Find('-') then begin //10
            "Settlement TypeR".Get(CReg."Settlement Type");
            "Settlement TypeR".TestField("Settlement TypeR"."Tuition G/L Account");
        end // 10
        else begin // 10.1
            Error('The Settlement Type Does not Exists in the Course Registration for: ' + Rec.Student);
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

        if Cust.Get(Rec.Student) then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", 'SALES');
        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();
        //GenSetUp.TESTFIELD(GenSetUp."Pre-Payment Account");

        // Charge Student - Accommodation- if not charged
        StudentCharges.Reset;
        StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
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
                if Cust.Get(Rec.Student) then begin
                    if Cust."Bill-to Customer No." <> '' then
                        GenJnl."Account No." := Cust."Bill-to Customer No."
                    else
                        GenJnl."Account No." := Rec.Student;
                end;

                GenJnl.Amount := StudentCharges.Amount;
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description := StudentCharges.Description;
                GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";

                if (StudentCharges."Transaction Type" = StudentCharges."transaction type"::"Stage Fees") and
                   (StudentCharges.Charge = false) then begin
                    GenJnl."Bal. Account No." := "Settlement TypeR"."Tuition G/L Account";

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
                        GenJnl."Bal. Account No." := "Settlement TypeR"."Tuition G/L Account";


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
                            if Cust.Get(Rec.Student) then begin
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
                                GenJnl."Account No." := "Settlement TypeR"."Tuition G/L Account";
                                GenJnl.Amount := StudentCharges.Amount * (StudentCharges.Distribution / 100);
                                GenJnl.Validate(GenJnl."Account No.");
                                GenJnl.Validate(GenJnl.Amount);
                                GenJnl.Description := 'Fee Distribution';
                                GenJnl."Bal. Account Type" := GenJnl."bal. account type"::"G/L Account";
                                //GenJnl."Bal. Account No.":=Stages."Distribution Account";

                                StudentCharges.CalcFields(StudentCharges."Settlement Type");
                                "Settlement TypeR".Get(StudentCharges."Settlement Type");
                                GenJnl."Bal. Account No." := "Settlement TypeR"."Tuition G/L Account";

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

        Message('The Accommodation charge was generated and posted successfuly.');

    end;

    local procedure postChargeReversal()
    begin
        //BILLING
        charges1.Reset;
        charges1.SetRange(charges1.Hostel, true);
        if not charges1.Find('-') then begin
            Error('The charges Setup does not have an item tagged as Hostel.');
        end;

        AccPayment := false;
        CReg.Reset;
        CReg.SetRange(CReg."Student No.", Rec.Student);
        CReg.SetRange(CReg.Semester, Rec.Semester);
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
        end; //5

        CReg.Reset;
        CReg.SetRange(CReg."Student No.", Rec.Student);
        CReg.SetRange(CReg.Semester, Rec.Semester);
        if CReg.Find('-') then begin //10
            "Settlement TypeR".Get(CReg."Settlement Type");
            "Settlement TypeR".TestField("Settlement TypeR"."Tuition G/L Account");
        end // 10
        else begin // 10.1
            Error('The Settlement Type Does not Exists in the Course Registration for: ' + Rec.Student);
        end;//10.1

        if prog.Get(CReg.Programme) then;

        if Cust.Get(Rec.Student) then;

        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", 'SALES');
        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
        GenJnl.DeleteAll;

        GenSetUp.Get();

        // Reverse Accomodation if charged

        DueDate := Today;

        if DueDate = 0D then DueDate := Today;

        GenJnl.Init;
        GenJnl."Line No." := GenJnl."Line No." + 10000;
        GenJnl."Posting Date" := Today;
        GenJnl."Document No." := CReg."Reg. Transacton ID" + '-' + Rec."Space No";
        GenJnl.Validate(GenJnl."Document No.");
        GenJnl."Journal Template Name" := 'SALES';
        GenJnl."Journal Batch Name" := 'STUD PAY';
        GenJnl."Account Type" := GenJnl."account type"::Customer;
        //
        if Cust.Get(Rec.Student) then begin
            if Cust."Bill-to Customer No." <> '' then
                GenJnl."Account No." := Cust."Bill-to Customer No."
            else
                GenJnl."Account No." := Rec.Student;
        end;

        GenJnl.Amount := -Rec.Charges;
        GenJnl.Validate(GenJnl."Account No.");
        GenJnl.Validate(GenJnl.Amount);
        GenJnl.Description := 'Accommodation Reversal ' + Rec."Space No";
        GenJnl."Bal. Account Type" := GenJnl."account type"::"G/L Account";
        GenJnl."Bal. Account No." := charges1."G/L Account";

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


        //Post New
        GenJnl.Reset;
        GenJnl.SetRange("Journal Template Name", 'SALES');
        GenJnl.SetRange("Journal Batch Name", 'STUD PAY');
        if GenJnl.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill", GenJnl);
        end;

        //Post New

        Message('The Accommodation charge was Reversed.');
    end;

    procedure clearFromRoom_Reversal()
    var
        Rooms: Record "Hostel Block Rooms";
        spaces: Record "Room Spaces";
        hostLedger: Record "Hostel Ledger";
        HostRooms: Record "Students Hostel Rooms";
    begin
        hostLedger.Reset;
        hostLedger.SetRange(hostLedger."Hostel No", Rec."Hostel No");
        hostLedger.SetRange(hostLedger."Room No", Rec."Room No");
        hostLedger.SetRange(hostLedger."Space No", Rec."Space No");

        if hostLedger.Find('-') then begin
            repeat
            begin
                HostRooms.Reset;
                HostRooms.SetRange(HostRooms.Student, hostLedger."Student No");
                //HostRooms.SETRANGE(HostRooms."Academic Year",hostLedger."Academic Year");
                HostRooms.SetRange(HostRooms.Semester, hostLedger.Semester);
                HostRooms.SetRange(HostRooms."Hostel No", hostLedger."Hostel No");
                HostRooms.SetRange(HostRooms."Room No", hostLedger."Room No");
                HostRooms.SetRange(HostRooms."Space No", hostLedger."Space No");
                HostRooms.SetFilter(HostRooms.Cleared, '=%1', false);
                if HostRooms.Find('-') then begin
                    HostRooms.Cleared := true;
                    HostRooms."Clearance Date" := Today;
                    HostRooms.Modify;
                end;

            end;
            until hostLedger.Next = 0;
        end;

        hostLedger.DeleteAll;
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
}

