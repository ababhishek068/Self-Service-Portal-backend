Page 50101 "Room Spaces list"
{
    PageType = List;
    SourceTable = "Room Spaces";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RoomCode; Rec."Room Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Code field.';
                }
                field(BedSpaces; Rec."Space Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bed Spaces';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Bed Spaces field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(RoomCost; Rec."Room Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Cost field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(BlackListreason; Rec."Black List reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Black List reason field.';
                }
                field(HostelCode; Rec."Hostel Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hostel Code field.';
                }
                field(RoomNotAvaillable; Rec."Room Not Availlable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Not Availlable field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Blacklist)
            {
                ApplicationArea = Basic;
                Caption = 'Black list';
                Image = AddAction;
                Promoted = true;
                ToolTip = 'Executes the Black list action.';

                trigger OnAction()
                begin
                    if Confirm('Blacklist this Room-Space?', false) = false then Error('Cancelled by user!');
                    if Rec."Black List reason" = '' then Error('please provide a Black list reason');
                    Rec.Status := Rec.Status::"Black-Listed";
                    Rec.Modify;
                    Message('The Room-Space has been successfully black-listed.');
                end;
            }
            action(UnBlacklist)
            {
                ApplicationArea = Basic;
                Caption = 'Un-Blacklist';
                Image = "Action";
                Promoted = true;
                ToolTip = 'Executes the Un-Blacklist action.';

                trigger OnAction()
                begin
                    if Confirm('Un-blacklist this Room-Space', true) = false then Error('Cancelled by user!');
                    Rec.Status := Rec.Status::Vaccant;
                    Rec."Black List reason" := '';
                    Rec.Modify;
                    Message('Room-Space un-blacklisted Successfully');
                end;
            }
            action(Vacate)
            {
                ApplicationArea = Basic;
                Caption = 'Vacate';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Vacate action.';

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

