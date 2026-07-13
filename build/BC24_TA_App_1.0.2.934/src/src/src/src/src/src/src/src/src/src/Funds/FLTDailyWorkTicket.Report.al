Report 50243 "FLT Daily Work Ticket"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLTDailyWorkTicket.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("FLT-Daily Work Ticket Header"; "FLT-Daily Work Ticket Header")
        {
            RequestFilterFields = "Ticket No.";
            column(ReportForNavId_1; 1) { }
            column(Min_Name; 'MINISTRY OF ' + Ministry) { }
            column(dept; UpperCase(Department + ' - ' + "Department Name")) { }
            column(ticNo; "Ticket No.") { }
            column(prevTick; "FLT-Daily Work Ticket Header"."Previous W.T. No.") { }
            column(GK_No; "FLT-Daily Work Ticket Header"."G.K. No.") { }
            column(make; "FLT-Daily Work Ticket Header".Make) { }
            column(Type; "FLT-Daily Work Ticket Header".Type) { }
            column(Unit; "FLT-Daily Work Ticket Header".Unit) { }
            column(stattion; "FLT-Daily Work Ticket Header".Station) { }
            dataitem("FLT-Ticket Authorizing Off."; "FLT-Ticket Authorizing Off.")
            {
                DataItemLink = "Ticket No." = field("Ticket No.");
                column(ReportForNavId_2; 2) { }

                trigger OnAfterGetRecord()
                begin

                    RecordNo2 := RecordNo2 + 1;
                    ColumnNo2 := ColumnNo2 + 1;

                    offCount := offCount + 1;

                    CalcFields("FLT-Ticket Authorizing Off."."Officer Name");
                    //Addr[ColumnNo][1] := FORMAT("line No.");
                    Address[1] [1] := Format("Officer No.") + ': ' + Format("Officer Name");
                    if offCount = 1 then begin
                        Off1 := Address[1] [1];
                    end else
                        if offCount = 2 then begin
                            Off2 := Address[1] [1];
                        end
                        else
                            if offCount = 3 then begin
                                Off3 := Address[1] [1];
                            end;

                    //Addr[ColumnNo][3] := FORMAT("Driver Name");
                    //Addr[ColumnNo][4] := FORMAT("Total Milleage");
                    //Addr[ColumnNo][5] := FORMAT("Total Fuel Consumed");
                    //Addr[ColumnNo][6] := FORMAT("Ticket No.");

                    CompressArray(Address[1]);

                    if RecordNo2 = NoOfRecords2 then begin
                        for j := ColumnNo2 + 1 to NoOfColumns2 do
                            Clear(Address[j]);
                        ColumnNo2 := 0;
                    end else begin
                        if ColumnNo2 = NoOfColumns2 then
                            ColumnNo2 := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfRecords := Count;
                    NoOfColumns := 1;
                    offCount := 0;
                    Off1 := '';
                    Off2 := '';
                    Off3 := '';
                end;
            }
            dataitem("FLT-Daily Work Ticked Drivers"; "FLT-Daily Work Ticked Drivers")
            {
                DataItemLink = "Ticket No." = field("Ticket No.");
                column(ReportForNavId_3; 3) { }

                trigger OnAfterGetRecord()
                begin

                    RecordNo := RecordNo + 1;
                    ColumnNo := ColumnNo + 1;
                    DriveCount := DriveCount + 1;

                    CalcFields("FLT-Daily Work Ticked Drivers"."Driver Name");
                    //Addr[ColumnNo][1] := FORMAT("line No.");
                    Addr[ColumnNo] [1] := Format("Driver No.") + ': ' + Format("Driver Name");

                    if DriveCount = 1 then begin
                        Drive1 := Addr[1] [1];
                    end else
                        if DriveCount = 2 then begin
                            Drive2 := Addr[2] [1];
                        end
                        else
                            if DriveCount = 3 then begin
                                Drive3 := Addr[1] [1];
                            end
                            else
                                if DriveCount = 4 then begin
                                    Drive4 := Addr[2] [1];
                                end else
                                    if DriveCount = 5 then begin
                                        Drive5 := Addr[1] [1];
                                    end
                                    else
                                        if DriveCount = 6 then begin
                                            Drive6 := Addr[2] [1];
                                        end;


                    //Addr[ColumnNo][3] := FORMAT("Driver Name");
                    //Addr[ColumnNo][4] := FORMAT("Total Milleage");
                    //Addr[ColumnNo][5] := FORMAT("Total Fuel Consumed");
                    //Addr[ColumnNo][6] := FORMAT("Ticket No.");

                    CompressArray(Addr[ColumnNo]);

                    if RecordNo = NoOfRecords then begin
                        for i := ColumnNo + 1 to NoOfColumns do
                            Clear(Addr[i]);
                        ColumnNo := 0;
                    end else begin
                        if ColumnNo = NoOfColumns then
                            ColumnNo := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin

                    NoOfRecords := Count;
                    NoOfColumns := 2;
                    DriveCount := 0;
                    Drive1 := '';
                    Drive2 := '';
                    Drive3 := '';
                    Drive4 := '';
                    Drive5 := '';
                    Drive6 := '';
                end;
            }
            dataitem("FLT-Daily Work Ticket Lines"; "FLT-Daily Work Ticket Lines")
            {
                DataItemLink = "Ticket No." = field("Ticket No.");
                column(ReportForNavId_4; 4) { }
                column(Drive1; Drive1) { }
                column(Drive2; Drive2) { }
                column(Drive3; Drive3) { }
                column(Drive4; Drive4) { }
                column(Drive5; Drive5) { }
                column(Drive6; Drive6) { }
                column(Off1; Off1) { }
                column(Off2; Off2) { }
                column(Off3; Off3) { }
                column(W_date; "FLT-Daily Work Ticket Lines"."Work Date") { }
                column(Drive_No; "FLT-Daily Work Ticket Lines"."Driver No.") { }
                column(Route; Format('From ' + "Departure From" + ' To ' + Destination)) { }
                column(Auth_Ifficer; "FLT-Daily Work Ticket Lines"."Authorizing Officer No") { }
                column(Oil_Consumed; "FLT-Daily Work Ticket Lines"."Total Oil Consumed") { }
                column(Fuel_Consumed; "FLT-Daily Work Ticket Lines"."Fuel Consumed (Litres)") { }
                column(Vouch_No; "FLT-Daily Work Ticket Lines"."Voucher No.") { }
                column(Time_out; "FLT-Daily Work Ticket Lines"."Time Out") { }
                column(Time_In; "FLT-Daily Work Ticket Lines"."Time In") { }
                column(End_Milleage; "FLT-Daily Work Ticket Lines"."End Milleage") { }
                column(Kilo_Covered; "FLT-Daily Work Ticket Lines"."Kilometers Covered") { }
            }

            trigger OnAfterGetRecord()
            begin

                ColumnNo2 := 0;
                ColumnNo := 0;
                CalcFields("Department Name");
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Addr: array[2, 1] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        Address: array[1, 1] of Text[250];
        NoOfRecords2: Integer;
        RecordNo2: Integer;
        NoOfColumns2: Integer;
        ColumnNo2: Integer;
        j: Integer;
        offCount: Integer;
        Off1: Text[250];
        Off2: Text[250];
        Off3: Text[250];
        Drive1: Text[250];
        Drive2: Text[250];
        Drive3: Text[250];
        Drive4: Text[250];
        Drive5: Text[250];
        Drive6: Text[250];
        DriveCount: Integer;
}

