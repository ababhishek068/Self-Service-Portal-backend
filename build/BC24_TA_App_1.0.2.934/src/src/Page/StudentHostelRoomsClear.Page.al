Page 50104 "Student Hostel Rooms Clear"
{
    PageType = ListPart;
    SourceTable = "Students Hostel Rooms";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
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
                        Creg.Reset;
                        Creg.SetRange(Creg."Student No.", Rec.Student);
                        Creg.SetRange(Creg.Semester, Sem.Code);
                        // Creg.SETRANGE(Creg.Posted,TRUE);
                        if Creg.Find('-') then
                            Registered := Creg.Registered;

                        GenSetup.Get;
                        if GenSetup."Allow UnPaid Hostel Booking" = false then begin
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
                field(AccomodationFee; Rec."Accomodation Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Accomodation Fee field.';
                }
                field(AllocationDate; Rec."Allocation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allocation Date field.';
                }
                field(Charges; Rec.Charges)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Charges field.';
                }
                field(Cleared; Rec.Cleared)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared field.';
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
                    Creg.Reset;
                    Creg.SetFilter(Creg."Student No.", Rec.Student);
                    Creg.SetFilter(Creg.Semester, Rec.Semester);
                    if Creg.Find('-') then
                        Report.Run(70134851, true, true, Creg);
                end;
            }
        }
    }

    var
        HostelLedger: Record "Hostel Ledger";
        StudentCharges: Record "Student Charges";
        PaidAmt: Decimal;
        ChargesRec: Record Charge;
        Cust: Record Customer;
        GenSetup: Record "General Set-Up";
        Creg: Record "Course Registration";
        Sem: Record Semesters;
        Registered: Boolean;

    procedure "Book Room"()
    begin

        StudentCharges.SetRange(StudentCharges."Student No.", Rec.Student);
        StudentCharges.SetRange(StudentCharges.Semester, Rec.Semester);
        StudentCharges.SetRange(Posted, true);
        if StudentCharges.Find('-') then begin
            ChargesRec.SetRange(ChargesRec.Code, StudentCharges.Code);
            if ChargesRec.Find('-') then begin
                PaidAmt := ChargesRec.Amount
            end;
        end;
        if PaidAmt > Rec."Accomodation Fee" then begin
            //StudentCharges."Over Charged":=TRUE;
            //StudentCharges."Over Charged Amount":=PaidAmt-"Accomodation Fee";
            // StudentCharges.MODIFY;
            Rec."Over Paid" := true;
            Rec."Over Paid Amt" := PaidAmt - Rec."Accomodation Fee";
        end else begin
            if PaidAmt <> Rec."Accomodation Fee" then begin

                Error('Accomodation Fee Paid Can Not Book This Room The Paid Amount is ' + Format(PaidAmt))
            end;
        end;
    end;
}

