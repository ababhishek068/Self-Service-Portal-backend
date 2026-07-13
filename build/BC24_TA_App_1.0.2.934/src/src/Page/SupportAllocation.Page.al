Page 50298 "Support Allocation"
{
    PageType = List;
    SourceTable = "Project Task Allocation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Allocation Remarks"; Rec."Allocation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allocation Remarks field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("Support Issue Description"; Rec."Support Issue Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Support Issue Description field.';
                }
                field("Consoltant Status"; Rec."Consoltant Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Consoltant Status field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Request Closure")
            {
                ApplicationArea = Basic;
                Image = ResetStatus;
                Promoted = true;
                ToolTip = 'Executes the Request Closure action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to submit the selected ticket for closure?') then begin
                        Rec.TestField("Solution Type");
                        Rec.TestField("Solution Remarks");
                        ClosureRec.Init;
                        ClosureRec."Task Entry No" := Rec."Support Entry No";
                        ClosureRec."Staff No" := Rec."Staff No";
                        ClosureRec."Staff Remarks" := Rec."Solution Remarks";
                        ClosureRec."Request Date" := Today;
                        ClosureRec.Insert(true);
                        Rec.Status := Rec.Status::"Pending Confirmation";
                        Rec.Modify;
                    end;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        msg: Text;
        WebPortal: Codeunit HRWebportal;
        HREmp: Record "HR-Employee";
    begin
        Rec."Consoltant Status" := Rec."consoltant status"::Assigned;

        if HREmp.get(Rec."Staff No") then begin
            Rec.CalcFields(Customer);
            Rec.CalcFields("Support Issue Description");
            msg := 'Ticket Number : ' + Format(Rec."Support Entry No") + '(' + Rec.Customer + ') has been assigned to you. ' +
                                '. The issue is: <br/> <b /><i /> ' + Rec."Support Issue Description" + '<br/>' +
                                'Log into the portal and see more details about the ticket. Sort the issue and ensure you close it.';
            WebPortal.SendEmail(HREmp."Company E-Mail", 'TICKET ASSIGNMENT', msg);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Allocation Type" := Rec."allocation type"::" ";
    end;

    var
        ClosureRec: Record "Projects Task Closure";
}

