page 51468 "Promotion Card"
{
    ApplicationArea = All;
    Caption = 'Promotion Card';
    PageType = Card;

    SourceTable = HR_Promotion;

    layout
    {
        area(Content)
        {
            group("Current Information")
            {
                Caption = 'Current Information';

                field(Promtion_No; Rec.Promtion_No)
                {
                    ToolTip = 'Specifies the value of the Promtion_No field.', Comment = '%';
                }
                field(Employee_No; Rec.Employee_No)
                {
                    ToolTip = 'Specifies the value of the Employee_No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                
                field("Is HOD"; Rec."Is HOD")
                {
                    ToolTip = 'Specifies the value of the Is HOD field.', Comment = '%';
                }
                field("Job Id"; Rec."Job Id")
                {
                    ToolTip = 'Specifies the value of the Job Id field.', Comment = '%';
                }
                                
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.', Comment = '%';
                }
                
                field("Current Gross Pay"; Rec."Current Gross Pay")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Current Gross Pay field.', Comment = '%';
                }
                field(Sector; Sector)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable=false;
                }
                field(District; District)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the district field.';
                    Editable=false;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Editable=false;
                    Caption = 'Department';
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';

                }
                field("<GlobSal Dimension 1 Code>"; Rec."Global Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Branch';
                    ShowMandatory = true;
                    Editable=false;
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                    end;
                }
                
                field(Division; Division)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Caption = 'Division';
                    Editable=false;

                }
                field("Work Station";"Work Station"){Editable=false;}
                
            }
            group("New information")
            {
                Caption = ' New information';

                field("New Job Id"; Rec."New Job Id")
                {
                    ToolTip = 'Specifies the value of the New Job Id field.', Comment = '%';
                }
                field("New Salary Grade"; Rec."New Salary Grade")
                {
                    ToolTip = 'Specifies the value of the New Salary Grade field.', Comment = '%';
                }
                 field("New Sector";"New Sector")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("New District";"New District")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the district field.';
                }
                field("New Global Dimension 2 Code";"New Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Caption = 'New Department';
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';

                }
                field("New Global Dimension 3 Code";"New Global Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Branch';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                    end;
                }                
                field("New Division";"New Division")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Caption = 'New Division';

                }
                field("New Work Station";"New Work Station"){}
                field("Is Now HOD"; "Is Now HOD") { }
            }
            group("Promotion Details")
            {
                Caption = ' Promotion Details';

                field("type"; Rec."type")
                {
                    ToolTip = 'Specifies the value of the type field.', Comment = '%';
                }
                field("New Position Start Date";"New Position Start Date"){}
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ToolTip = 'Specifies the value of the Time Created field.', Comment = '%';
                }
                field("Key Experience"; Rec."Key Experience")
                {
                    ToolTip = 'Specifies the value of the Key Experience field.', Comment = '%';
                }
                field("Reason Description"; Rec."Reason Description")
                {
                    ToolTip = 'Specifies the value of the Reason Description field.', Comment = '%';
                }
                field(posted; posted) { }
            }
        }
    }
    actions
    {
        area(processing)
        {

            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RECORDID);
                end;
            }

            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Enabled = true;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Send Approval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action("Cancel Approval Request")
            {
                Caption = 'Cancel Approval Request';
                Enabled = true;
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the Cancel Approval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }
            separator(Separator40) { }
            action("Post Promotion/Demotion")
            {
                Caption = 'Post Promotion/Demotion';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = Basic;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                var
                    emps: Record "HR-Employee";

                begin

                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.TestField(posted, false);
                    rec.TestField("New Position Start Date");
                    if ("New District"<>'') or ("New Division"<>'') or("New Sector"<>'') or ("New Global Dimension 2 Code"<>'') or ("New Global Dimension 3 Code"<>'')or
                    ("New Job Id"<>'') or ("New Salary Grade"<>0)  or ("New Work Station"<>'')  then begin
                    UpdateProfile(Rec);
                    PostPromotion(Rec);
                    Rec.Posted := true;
                    Rec."Posted By" := UserId;
                    Rec."Date posted" := CurrentDateTime;
                    Rec.Modify;
                    
                    CurrPage.SaveRecord;
                    // Message('The promotion/Demotion has been posted successfully in internal employement history');
                    // //Check card opening-Felix

                    //     if Confirm('Do you wish to view Internal Employment History?') then begin
                    //         emps.Reset();
                    //         emps.SetRange(emps."No.", Rec.Employee_No);
                    //         if emps.FindFirst() then begin
                    //             Page.RunModal(Page::"Internal Employee History", emps,emps."Employee No. Filter");
                    //             //CurrPage.SetTableView(emps."No."); // Example filtering               


                    //         end;                            


                    // end else begin

                    //     end;
                    end else begin
                        Error('There is nothing to post');
                    end;



                end;
                //
            }
        }



        area(Reporting)
        {

            action("Print Promotion/Demotion Letter")
            {
                Caption = 'Print Promotion/Demotion Letter';
                Enabled = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = basic;
                ToolTip = 'Executes the print action.';
            }

        }

    }

    local procedure PostPromotion(Rec: Record HR_Promotion)
    var
        internalpromotion: Record "Internal Employment History";
    begin
        internalpromotion.Reset();
        internalpromotion.SetRange(internalpromotion.Promotion_No, Rec.Promtion_No);
        if internalpromotion.FindFirst() then begin
            Error('This promotion is already posted on employee internal employement history');
        end else if not internalpromotion.find() then begin
            internalpromotion.Init();
            internalpromotion.Promotion_No := rec.Promtion_No;
            internalpromotion.current := true;
            internalpromotion.Validate(current);            
            internalpromotion.From := rec."New Position Start Date";
            internalpromotion."Employee No." := rec.Employee_No;
            internalpromotion.Status := Rec.Status;
            internalpromotion."Reason for Change" := rec.type;
            internalpromotion."Reason Description" := rec."Reason Description";
            internalpromotion.Comment := rec.Comment;
            if "New Sector"<>'' then begin
            internalpromotion.Sector:=rec."New Sector";
            end;
            if "New District"<>'' then begin
            internalpromotion.District:=rec."New District";
            end;
            if "New Global Dimension 2 Code"<>'' then begin
            internalpromotion."Global Dimension 2 Code" := rec."New Global Dimension 2 Code";
            end;
            if "New Global Dimension 3 Code"<>'' then begin
            internalpromotion."Global Dimension 3 Code" := rec."New Global Dimension 3 Code";
            end;
            if "New Division"<>'' then  begin
            internalpromotion.Division:=rec."New Division";
            end;           
            
             if "New Work Station"<>'' then begin
            internalpromotion."Work Station":=rec."New Work Station";
             end;
             if "New Salary Grade"<>0 then begin            
            internalpromotion.Grade := rec."New Salary Grade";  
             end;
             if "New Job Id"<>'' then begin         
            internalpromotion."Job ID" := rec."New Job Id";
             end;
            internalpromotion."Key Experience" := rec."Key Experience";
            internalpromotion."Promoted to HoD" := rec."Is Now HOD";
            internalpromotion.Insert;
        end;
        //Error('Procedure PostPromotion not implemented.');

    end;


    local procedure UpdateProfile(Rec: Record HR_Promotion)
    var
        profile: Record "HR-Employee";
    begin
        profile.Reset();
        profile.SetRange(profile."No.", Rec.Employee_No);
        if profile.FindFirst() then begin
            if "New Sector">'' then begin
            profile.Sector:=rec."New Sector";
            profile.Validate(Sector);
        end;
            if "New District"<>'' then begin
            profile."Business Unit":=rec."New District";
            end;
            if "New Division"<>'' then begin
                profile.Division:=rec.Division;
            end;
            if "New Global Dimension 2 Code"<>'' then begin
                profile."Global Dimension 2 Code" := rec."New Global Dimension 2 Code";
            end;
            if "New Global Dimension 3 Code"<>'' then begin            
            profile."Global Dimension 3 Code":=rec."New Global Dimension 3 Code";
            end;
            if "New Work Station"<>'' then begin
            profile."Work Station":=rec."New Work Station";
            profile.Validate("Work Station");  
               end;
               if "New Salary Grade"<>0 then begin           
            profile.Grade := rec."New Salary Grade";
            profile.Validate(Grade);
               end;
               if "New Job Id"<>'' then begin           
            profile."Job ID" := rec."New Job Id";
            profile.Validate("Job ID");
               end;
               
            profile.Modify();
        end;
        //Error('Procedure PostPromotion not implemented.');

    end;

}

// procedure PostPromotion(var Promotion, Rec: Record HR_Promotion)
// var
// internalpromotion: Record "Internal Employment History";