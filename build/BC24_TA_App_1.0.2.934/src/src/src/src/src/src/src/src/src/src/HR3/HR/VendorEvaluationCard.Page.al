namespace ABH_UAT.ABH_UAT;

page 51545 "Vendor Evaluation Card"
{
    
    ApplicationArea = All;
    Caption = 'Vendor Evaluation Card';
    PageType = Card;
    SourceTable = "Vendor Evaluation Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Evaluation Code"; Rec."Evaluation Code")
                {
                    ToolTip = 'Specifies the value of the Evaluation Code field.', Comment = '%';
                }
                field(Vendor;Vendor){}
                field("Vendor Name";"Vendor Name"){}
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Employee name"; Rec."Employee name")
                {
                    ToolTip = 'Specifies the value of the Employee name field.', Comment = '%';
                }
                field("Manager Id"; Rec."Manager Id")
                {
                    ToolTip = 'Specifies the value of the Manager Id field.', Comment = '%';
                }
                field("Manager Name"; Rec."Manager Name")
                {
                    ToolTip = 'Specifies the value of the Manager Name field.', Comment = '%';
                }
                               field("Created By"; Rec."Created By")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Average Score";"Average Score"){
                    Editable=false;
                }
            }
            part(evaluationlines; "vendor Evaluation line")
            {
                SubPageLink = "Employee Code" = field("Employee Code"), "Provider Code" = field(Vendor),"Date Created"=field("Date Created");
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Evaluate)
            {
                Caption = 'Evaluate';
                ApplicationArea = basic;
                Image = ImplementRegAbsence;
                trigger OnAction()
                begin
                    TestField("Employee Code");
                    TestField(Vendor);
                    TestField("Date Created");
                   
                    evaluationlines.Reset();                   
                    evaluationlines.SetRange(evaluationlines."Employee Code", "Employee Code");
                    evaluationlines.SetRange(evaluationlines."Provider Code", vendor);
                    evaluationlines.SetRange("Date Created", "Date Created");
                    if evaluationlines.Find('-') then begin
                        repeat

                        until evaluationlines.Next = 0;

                    end else if not evaluationlines.Find() then begin
                        evaluationchecklist.Reset();
                        evaluationchecklist.SetRange(evaluationchecklist."Active?", true);
                        if evaluationchecklist.Find('-') then begin
                            repeat
                                evaluationlines.init;
                                evaluationlines."Employee Code" := "Employee Code";
                                evaluationlines."Date Created":="Date Created";                               
                                //evaluationlines.
                                evaluationlines."Provider Code" := Vendor;
                                evaluationlines."Rate Code" := evaluationchecklist.Code;
                                evaluationlines."Rate Factor" := evaluationchecklist."Rating Factor";

                                evaluationlines.Insert;


                            until evaluationchecklist.next = 0;
                            Message('Rating Criteria added, please rate each line');
                        end;

                    end;

                end;
            }
        }
    }
    var

        evaluationchecklist: Record "Vendor Evaluation Factors";
        evaluationlines: Record "Vendor Evaluation Lines";

}

