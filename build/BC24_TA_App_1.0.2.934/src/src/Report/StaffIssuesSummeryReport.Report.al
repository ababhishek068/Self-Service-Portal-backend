Report 50025 "Staff Issues Summery Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Issues Summery Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(UnknownTable50072; "HR-Employee")
        {
            DataItemTableView = sorting("No.") order(ascending) where(Status = filter(Active));
            column(ReportForNavId_1; 1) { }
            column(No_HREmployee; "No.") { }
            column(Names; Name) { }
            column(ComImg; CompanyInfo.Picture) { }
            column(Open; Open) { }
            column(Pending; Pending) { }
            column(Closed; Closed) { }
            column(Open1; Open1) { }
            column(Pending1; Pending1) { }
            column(Closed1; Closed1) { }
            column(ReportTitle; ReportTitle) { }
            column(Counter; i) { }
            column(Tier1; Tier1) { }
            column(Tier2; Tier2) { }
            column(Tier3; Tier3) { }
            column(Tier4; Tier4) { }
            column(Tier11; Tier11) { }
            column(Tier21; Tier21) { }
            column(Tier31; Tier31) { }
            column(Tier41; Tier41) { }

            trigger OnAfterGetRecord()
            var
                ProjectTaskAllocation: Record "Project Task Allocation";
                NewDate: Integer;
            begin
                Name := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
                Open := 0;
                Pending := 0;
                Closed := 0;
                Open1 := 0;
                Pending1 := 0;
                Closed1 := 0;
                NewDate := 0;

                Tier1 := 0;
                Tier2 := 0;
                Tier3 := 0;
                Tier4 := 0;
                Tier11 := 0;
                Tier21 := 0;
                Tier31 := 0;
                Tier41 := 0;
                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Support);
                ProjectTaskAllocation.SetFilter(Status, '%1|%2', ProjectTaskAllocation.Status::Open, ProjectTaskAllocation.Status::"On-Going");
                if ProjectTaskAllocation.Find('-') then Open := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Implementation);
                ProjectTaskAllocation.SetFilter(Status, '%1|%2', ProjectTaskAllocation.Status::Open, ProjectTaskAllocation.Status::"On-Going");
                if ProjectTaskAllocation.Find('-') then Open1 := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Support);
                ProjectTaskAllocation.SetFilter(Status, '%1|%2', ProjectTaskAllocation.Status::Open, ProjectTaskAllocation.Status::"On-Going");
                if ProjectTaskAllocation.Find('-') then begin
                    repeat
                        NewDate := 0;
                        ProjectTaskAllocation.CalcFields("Date Reported");
                        if ProjectTaskAllocation."Date Reported" <> 0D then begin
                            NewDate := (Today - ProjectTaskAllocation."Date Reported") + 1;
                            if NewDate <= 14 then Tier1 := Tier1 + 1;
                            if ((NewDate > 14) and (NewDate <= 90)) then Tier2 := Tier2 + 1;
                            if ((NewDate > 90) and (NewDate <= 180)) then Tier3 := Tier3 + 1;
                            if NewDate > 180 then Tier4 := Tier4 + 1;
                        end;
                    until ProjectTaskAllocation.Next = 0;
                end;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Implementation);
                ProjectTaskAllocation.SetFilter(Status, '%1|%2', ProjectTaskAllocation.Status::Open, ProjectTaskAllocation.Status::"On-Going");
                if ProjectTaskAllocation.Find('-') then begin
                    repeat
                        NewDate := 0;
                        ProjectTaskAllocation.CalcFields("Date Reported");
                        if ProjectTaskAllocation."Date Reported" <> 0D then begin
                            NewDate := (Today - ProjectTaskAllocation."Date Reported") + 1;
                            if NewDate <= 14 then Tier11 := Tier11 + 1;
                            if ((NewDate > 14) and (NewDate <= 90)) then Tier21 := Tier21 + 1;
                            if ((NewDate > 90) and (NewDate <= 180)) then Tier31 := Tier31 + 1;
                            if NewDate > 180 then Tier41 := Tier41 + 1;
                        end;
                    until ProjectTaskAllocation.Next = 0;
                end;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Support);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::"Pending Confirmation");
                if ProjectTaskAllocation.Find('-') then Pending := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Implementation);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::"Pending Confirmation");
                if ProjectTaskAllocation.Find('-') then Pending1 := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Support);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::Closed);
                if ProjectTaskAllocation.Find('-') then Closed := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Allocation Type", ProjectTaskAllocation."allocation type"::Implementation);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::Closed);
                if ProjectTaskAllocation.Find('-') then Closed1 := ProjectTaskAllocation.Count;

                i := i + 1;
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

        i := 0;
    end;

    var
        Name: Text;
        Open: Integer;
        Pending: Integer;
        Closed: Integer;
        Open1: Integer;
        Pending1: Integer;
        Closed1: Integer;
        CompanyInfo: Record "Company Information";
        ReportTitle: Text;
        i: Integer;
        Tier1: Integer;
        Tier2: Integer;
        Tier3: Integer;
        Tier4: Integer;
        Tier11: Integer;
        Tier21: Integer;
        Tier31: Integer;
        Tier41: Integer;
}

