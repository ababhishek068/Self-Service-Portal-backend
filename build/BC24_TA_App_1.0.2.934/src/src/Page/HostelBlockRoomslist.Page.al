Page 50088 "Hostel Block Rooms list"
{
    Editable = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Hostel Block Rooms";
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
                field(RoomDescription; Rec."Room Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Description field.';
                }
                field(NoofSpaces; Rec."No of Spaces")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No of Spaces field.';
                }
                field(JABFees; Rec."JAB Fees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the JAB Fees field.';
                }
                field(SSPFees; Rec."SSP Fees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SSP Fees field.';
                }
                field(RoomCost; Rec."Room Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Room Cost field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(NotAvaillable; Rec."Not Availlable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Not Availlable field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(ReservationRemarks; Rec."Reservation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reservation Remarks field.';
                }
                field(ReservationUserID; Rec."Reservation UserID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reservation UserID field.';
                }
                field(ReservationDate; Rec."Reservation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reservation Date field.';
                }
                field("Vacant Spaces"; Rec."Vacant Spaces")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vacant Spaces field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Room Spaces")
            {
                ApplicationArea = Basic;
                Promoted = true;
                RunObject = Page "Room Spaces list";
                RunPageLink = "Hostel Code" = field("Hostel Code"),
                              "Room Code" = field("Room Code");
                ToolTip = 'Executes the Room Spaces action.';
            }
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
    begin

        /*hostLedger.RESET;
        hostLedger.SETRANGE(hostLedger."Hostel No","Hostel Code");
        hostLedger.SETRANGE(hostLedger."Room No","Room Code");
        //hostLedger.SETRANGE(hostLedger."Space No","Space Code");

        IF hostLedger.FIND('-') THEN BEGIN
        REPEAT
        BEGIN
       HostRooms.RESET;
       HostRooms.SETRANGE(HostRooms.Student,hostLedger."Student No");
       HostRooms.SETRANGE(HostRooms."Academic Year",hostLedger."Academic Year");
       HostRooms.SETRANGE(HostRooms.Semester,hostLedger.Semester);
       HostRooms.SETRANGE(HostRooms."Hostel No",hostLedger."Hostel No");
       HostRooms.SETRANGE(HostRooms."Room No",hostLedger."Room No");
       HostRooms.SETRANGE(HostRooms."Space No",hostLedger."Space No");
       IF HostRooms.FIND('-') THEN BEGIN
         HostRooms.Cleared:=TRUE;
         HostRooms."Clearance Date":=TODAY;
         HostRooms.MODIFY;
       END;
       hostLedger.DELETE;
         END;
         UNTIL hostLedger.NEXT=0;
        END;


       spaces.RESET;
       spaces.SETRANGE(spaces."Hostel Code","Hostel Code");
       spaces.SETRANGE(spaces."Room Code","Room Code");
       //spaces.SETRANGE(spaces."Space Code","Space Code");
       IF spaces.FIND('-') THEN BEGIN
       REPEAT
       BEGIN
       spaces.Status:=spaces.Status::Vaccant;
       spaces."Student No":='';
       spaces."Receipt No":='';
       spaces."Black List reason":='';
       spaces.MODIFY;
       END;
       UNTIL spaces.NEXT=0;
       END;

         Rooms.RESET;
        Rooms.SETRANGE(Rooms."Hostel Code","Hostel Code");
        Rooms.SETRANGE(Rooms."Room Code","Room Code");
        IF Rooms.FIND('-') THEN BEGIN
         REPEAT
          Rooms.VALIDATE(Rooms.Status);
         UNTIL Rooms.NEXT = 0;
        END;
        */

    end;
}

