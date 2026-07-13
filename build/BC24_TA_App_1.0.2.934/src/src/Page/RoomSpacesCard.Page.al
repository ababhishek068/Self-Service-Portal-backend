Page 50158 "Room Spaces Card"
{
    CardPageID = "Room Spaces list";
    PageType = Card;
    SourceTable = "Room Spaces";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(HostelCode; Rec."Hostel Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Hostel Code field.';
                }
                field(RoomCode; Rec."Room Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Room Code field.';
                }
                field(SpaceCode; Rec."Space Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Space Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ClearSpace)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Space';
                Image = ClearLog;
                Promoted = true;
                ToolTip = 'Executes the Clear Space action.';

                trigger OnAction()
                begin
                    if Confirm('Clear Space?', false) = true then begin
                        clearFromRoom();
                    end;
                end;
            }
        }
    }

    procedure clearFromRoom()
    var
        Rooms: Record "Hostel Block Rooms";
        spaces: Record "Room Spaces";
        hostLedger: Record "Hostel Ledger";
        HostRooms: Record "Students Hostel Rooms";
    begin
        hostLedger.Reset;
        hostLedger.SetRange(hostLedger."Hostel No", Rec."Hostel Code");
        hostLedger.SetRange(hostLedger."Room No", Rec."Room Code");
        hostLedger.SetRange(hostLedger."Space No", Rec."Space Code");

        if hostLedger.Find('-') then begin
            repeat
            begin
                HostRooms.Reset;
                HostRooms.SetRange(HostRooms.Student, hostLedger."Student No");
                HostRooms.SetRange(HostRooms."Academic Year", hostLedger."Academic Year");
                HostRooms.SetRange(HostRooms.Semester, hostLedger.Semester);
                HostRooms.SetRange(HostRooms."Hostel No", hostLedger."Hostel No");
                HostRooms.SetRange(HostRooms."Room No", hostLedger."Room No");
                HostRooms.SetRange(HostRooms."Space No", hostLedger."Space No");
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
        spaces.SetRange(spaces."Hostel Code", Rec."Hostel Code");
        spaces.SetRange(spaces."Room Code", Rec."Room Code");
        spaces.SetRange(spaces."Space Code", Rec."Space Code");
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
        Rooms.SetRange(Rooms."Hostel Code", Rec."Hostel Code");
        Rooms.SetRange(Rooms."Room Code", Rec."Room Code");
        if Rooms.Find('-') then begin
            repeat
                Rooms.Validate(Rooms.Status);
            until Rooms.Next = 0;
        end;
    end;
}

