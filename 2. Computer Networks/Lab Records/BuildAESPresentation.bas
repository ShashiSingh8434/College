Option Explicit
'==============================================================
' AES Presentation Builder  (CSE3006 - Computer Networks, Group 6)
' Run:  BuildAESPresentation
' Creates a NEW 16:9 presentation with 22 slides, everything drawn
' with native PowerPoint shapes (no images, no external files).
'==============================================================

Private pres As Presentation

Private cBG As Long, cPanel As Long, cPanel2 As Long, cAccent As Long
Private cAmber As Long, cText As Long, cMuted As Long, cGreen As Long
Private cRed As Long, cCode As Long, cTealD As Long, cTealM As Long
Private ARW As String, DSH As String, TMS As String, DOT As String
Private XORS As String, NEQ As String, MINUS As String

Private Const FONT_MAIN As String = "Segoe UI"
Private Const FONT_CODE As String = "Consolas"

'==============================================================
' MAIN
'==============================================================
Public Sub BuildAESPresentation()
    InitTheme
    Set pres = Application.Presentations.Add(msoTrue)
    pres.PageSetup.SlideWidth = 960
    pres.PageSetup.SlideHeight = 540

    Slide01: Slide02: Slide03: Slide04: Slide05: Slide06
    Slide07: Slide08: Slide09: Slide10: Slide11: Slide12
    Slide13: Slide14: Slide15: Slide16: Slide17: Slide18
    Slide19: Slide20: Slide21: Slide22

    On Error Resume Next
    ActiveWindow.View.GotoSlide 1
    On Error GoTo 0
    MsgBox "Done! " & pres.Slides.Count & " slides created.", vbInformation, "AES Presentation"
End Sub

Private Sub InitTheme()
    cBG = RGB(10, 17, 40)
    cPanel = RGB(24, 35, 66)
    cPanel2 = RGB(34, 50, 92)
    cAccent = RGB(0, 201, 177)
    cAmber = RGB(255, 193, 7)
    cText = RGB(235, 241, 255)
    cMuted = RGB(150, 165, 200)
    cGreen = RGB(76, 217, 130)
    cRed = RGB(255, 120, 110)
    cCode = RGB(6, 10, 26)
    cTealD = RGB(0, 110, 105)
    cTealM = RGB(0, 145, 130)
    ARW = ChrW(8594)
    DSH = ChrW(8211)
    TMS = ChrW(215)
    DOT = ChrW(8226)
    XORS = ChrW(8853)
    NEQ = ChrW(8800)
    MINUS = ChrW(8722)
End Sub

'==============================================================
' HELPERS
'==============================================================
Private Function Sup(ByVal x As String) As String
    Dim i As Long, ch As String, r As String
    For i = 1 To Len(x)
        ch = Mid$(x, i, 1)
        Select Case ch
            Case "0": r = r & ChrW(8304)
            Case "1": r = r & ChrW(185)
            Case "2": r = r & ChrW(178)
            Case "3": r = r & ChrW(179)
            Case "4" To "9": r = r & ChrW(8304 + CLng(ch))
            Case Else: r = r & ch
        End Select
    Next i
    Sup = r
End Function

Private Function BlankSlide() As Slide
    Dim s As Slide
    Set s = pres.Slides.Add(pres.Slides.Count + 1, ppLayoutBlank)
    s.FollowMasterBackground = msoFalse
    s.Background.Fill.Solid
    s.Background.Fill.ForeColor.RGB = cBG
    Set BlankSlide = s
End Function

Private Function NewSlide(ByVal ttl As String, ByVal kicker As String) As Slide
    Dim s As Slide, shp As Shape
    Set s = BlankSlide()
    Set shp = s.Shapes.AddShape(msoShapeRectangle, 0, 0, 12, 540)
    shp.Fill.ForeColor.RGB = cAccent
    shp.Line.Visible = msoFalse
    TB s, UCase(kicker), 40, 14, 700, 20, 12, cAccent, True
    TB s, ttl, 40, 32, 880, 48, 28, cText, True
    Set shp = s.Shapes.AddShape(msoShapeRectangle, 44, 84, 70, 3)
    shp.Fill.ForeColor.RGB = cAmber
    shp.Line.Visible = msoFalse
    TB s, "AES  |  CSE3006 Computer Networks  |  Group 6", 40, 510, 500, 20, 10, cMuted
    TB s, CStr(s.SlideIndex), 860, 510, 60, 20, 10, cMuted, False, ppAlignRight
    Set NewSlide = s
End Function

Private Function TB(s As Slide, ByVal txt As String, ByVal l As Single, ByVal t As Single, _
        ByVal w As Single, ByVal h As Single, ByVal sz As Single, ByVal col As Long, _
        Optional ByVal bld As Boolean = False, Optional ByVal al As Long = 1, _
        Optional ByVal fnt As String = "Segoe UI") As Shape
    Dim shp As Shape
    Set shp = s.Shapes.AddTextbox(msoTextOrientationHorizontal, l, t, w, h)
    With shp.TextFrame
        .WordWrap = msoTrue
        .AutoSize = ppAutoSizeNone
        .MarginLeft = 4: .MarginRight = 4: .MarginTop = 2: .MarginBottom = 2
        With .TextRange
            .Text = txt
            .Font.Name = fnt
            .Font.Size = sz
            .Font.Color.RGB = col
            .Font.Bold = bld
            .ParagraphFormat.Alignment = al
        End With
    End With
    shp.Height = h
    Set TB = shp
End Function

Private Function Box(s As Slide, ByVal txt As String, ByVal l As Single, ByVal t As Single, _
        ByVal w As Single, ByVal h As Single, ByVal fillCol As Long, ByVal txtCol As Long, _
        ByVal sz As Single, Optional ByVal bld As Boolean = True, _
        Optional ByVal shpType As Long = 5) As Shape
    Dim shp As Shape
    Set shp = s.Shapes.AddShape(shpType, l, t, w, h)
    shp.Fill.Solid
    shp.Fill.ForeColor.RGB = fillCol
    shp.Line.Visible = msoFalse
    shp.Shadow.Visible = msoFalse
    If shpType = 5 Then shp.Adjustments(1) = 0.12
    If fillCol = cAccent Or fillCol = cAmber Or fillCol = cGreen Then txtCol = cBG
    With shp.TextFrame
        .WordWrap = msoTrue
        .MarginLeft = 3: .MarginRight = 3: .MarginTop = 2: .MarginBottom = 2
        .VerticalAnchor = msoAnchorMiddle
        With .TextRange
            .Text = Replace(txt, "|", vbCr)
            .Font.Name = FONT_MAIN
            .Font.Size = sz
            .Font.Bold = bld
            .Font.Color.RGB = txtCol
            .ParagraphFormat.Alignment = ppAlignCenter
        End With
    End With
    Set Box = shp
End Function

Private Sub TwoLine(shp As Shape, ByVal sz1 As Single, ByVal sz2 As Single, ByVal col2 As Long)
    With shp.TextFrame.TextRange
        .Paragraphs(1).Font.Size = sz1
        .Paragraphs(2).Font.Size = sz2
        .Paragraphs(2).Font.Color.RGB = col2
    End With
End Sub

Private Function CodeBox(s As Slide, ByVal txt As String, ByVal l As Single, ByVal t As Single, _
        ByVal w As Single, ByVal h As Single, ByVal sz As Single) As Shape
    Dim shp As Shape
    Set shp = s.Shapes.AddShape(msoShapeRoundedRectangle, l, t, w, h)
    shp.Adjustments(1) = 0.06
    shp.Fill.Solid
    shp.Fill.ForeColor.RGB = cCode
    shp.Line.ForeColor.RGB = cAccent
    shp.Line.Weight = 1.25
    shp.Shadow.Visible = msoFalse
    With shp.TextFrame
        .WordWrap = msoTrue
        .MarginLeft = 12: .MarginRight = 12: .MarginTop = 6: .MarginBottom = 6
        .VerticalAnchor = msoAnchorMiddle
        With .TextRange
            .Text = txt
            .Font.Name = FONT_CODE
            .Font.Size = sz
            .Font.Bold = msoFalse
            .Font.Color.RGB = RGB(160, 255, 220)
            .ParagraphFormat.Alignment = ppAlignLeft
        End With
    End With
    Set CodeBox = shp
End Function

Private Function Bullets(s As Slide, ByVal items As Variant, ByVal l As Single, ByVal t As Single, _
        ByVal w As Single, ByVal h As Single, ByVal sz As Single) As Shape
    Dim i As Long, txt As String, pos As Long, clean As String, n As Long
    Dim shp As Shape
    For i = LBound(items) To UBound(items)
        pos = InStr(items(i), "~")
        If pos > 0 Then
            clean = Left$(items(i), pos - 1) & Mid$(items(i), pos + 1)
        Else
            clean = items(i)
        End If
        txt = txt & clean
        If i < UBound(items) Then txt = txt & vbCr
    Next i
    Set shp = TB(s, txt, l, t, w, h, sz, cText)
    With shp.TextFrame
        .Ruler.Levels(1).FirstMargin = 0
        .Ruler.Levels(1).LeftMargin = sz * 1.1
        With .TextRange.ParagraphFormat
            .Bullet.Visible = msoTrue
            .Bullet.Type = ppBulletUnnumbered
            .Bullet.Character = 8226
            .Bullet.UseTextColor = msoFalse
            .Bullet.Font.Color.RGB = cAccent
            .LineRuleAfter = msoFalse
            .SpaceAfter = sz * 0.45
        End With
    End With
    n = 0
    For i = LBound(items) To UBound(items)
        n = n + 1
        pos = InStr(items(i), "~")
        If pos > 1 Then
            With shp.TextFrame.TextRange.Paragraphs(n).Characters(1, pos - 1)
                .Font.Bold = msoTrue
                .Font.Color.RGB = cAccent
            End With
        End If
    Next i
    Set Bullets = shp
End Function

Private Sub ArrowR(s As Slide, ByVal l As Single, ByVal t As Single, _
        Optional ByVal w As Single = 30, Optional ByVal h As Single = 24)
    Dim shp As Shape
    Set shp = s.Shapes.AddShape(msoShapeRightArrow, l, t, w, h)
    shp.Fill.ForeColor.RGB = cAccent
    shp.Line.Visible = msoFalse
End Sub

Private Sub ArrowD(s As Slide, ByVal l As Single, ByVal t As Single, _
        Optional ByVal w As Single = 24, Optional ByVal h As Single = 20)
    Dim shp As Shape
    Set shp = s.Shapes.AddShape(msoShapeDownArrow, l, t, w, h)
    shp.Fill.ForeColor.RGB = cAccent
    shp.Line.Visible = msoFalse
End Sub

Private Function Rows4(ByVal c As Long) As Variant
    Rows4 = Array(c, c, c, c)
End Function

Private Function SeqLabels(ByVal prefix As String) As Variant
    Dim a(0 To 15) As String, r As Long, c As Long
    For r = 0 To 3
        For c = 0 To 3
            a(r * 4 + c) = prefix & CStr(r + 4 * c)
        Next c
    Next r
    SeqLabels = a
End Function

Private Sub DrawGrid(s As Slide, ByVal l As Single, ByVal t As Single, ByVal cw As Single, _
        ByVal ch As Single, ByVal nr As Long, ByVal nc As Long, ByVal labels As Variant, _
        ByVal fs As Single, ByVal fillCol As Long, Optional rowCols As Variant)
    Dim r As Long, c As Long, f As Long, shp As Shape
    For r = 0 To nr - 1
        For c = 0 To nc - 1
            f = fillCol
            If Not IsMissing(rowCols) Then f = CLng(rowCols(r))
            Set shp = Box(s, CStr(labels(LBound(labels) + r * nc + c)), l + c * cw, t + r * ch, _
                          cw - 3, ch - 3, f, cText, fs, True, msoShapeRectangle)
        Next c
    Next r
End Sub

Private Sub MakeTable(s As Slide, ByVal data As Variant, ByVal l As Single, ByVal t As Single, _
        ByVal w As Single, ByVal h As Single, ByVal fs As Single)
    Dim nr As Long, nc As Long, r As Long, c As Long, shp As Shape
    nr = UBound(data) + 1
    nc = UBound(data(0)) + 1
    Set shp = s.Shapes.AddTable(nr, nc, l, t, w, h)
    On Error Resume Next
    shp.Table.ApplyStyle "{2D5ABB26-0587-4C30-8999-92F81FD0307C}", False
    On Error GoTo 0
    For r = 1 To nr
        shp.Table.Rows(r).Height = h / nr
        For c = 1 To nc
            With shp.Table.Cell(r, c).Shape
                .Fill.Solid
                If r = 1 Then
                    .Fill.ForeColor.RGB = cAccent
                ElseIf r Mod 2 = 0 Then
                    .Fill.ForeColor.RGB = cPanel
                Else
                    .Fill.ForeColor.RGB = cPanel2
                End If
                With .TextFrame
                    .VerticalAnchor = msoAnchorMiddle
                    With .TextRange
                        .Text = CStr(data(r - 1)(c - 1))
                        .Font.Name = FONT_MAIN
                        .Font.Size = fs
                        .Font.Bold = (r = 1 Or c = 1)
                        .Font.Color.RGB = IIf(r = 1, cBG, cText)
                        .ParagraphFormat.Alignment = ppAlignCenter
                    End With
                End With
            End With
        Next c
    Next r
End Sub

Private Sub FlowRow(s As Slide, ByVal t As Single, ByVal h As Single, ByVal texts As Variant, _
        ByVal fills As Variant, ByVal sz As Single)
    Dim i As Long, l As Single, shp As Shape
    For i = 0 To 4
        l = 40 + i * 182
        Set shp = Box(s, CStr(texts(i)), l, t, 152, h, CLng(fills(i)), cText, sz)
        If i < 4 Then ArrowR s, l + 154, t + h / 2 - 12, 26, 24
    Next i
End Sub

Private Sub Line2(s As Slide, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, _
        ByVal y2 As Single, ByVal col As Long, ByVal wt As Single)
    Dim shp As Shape
    Set shp = s.Shapes.AddLine(x1, y1, x2, y2)
    shp.Line.ForeColor.RGB = col
    shp.Line.Weight = wt
End Sub

'==============================================================
' SLIDE 1 - TITLE
'==============================================================
Private Sub Slide01()
    Dim sld As Slide
    Set sld = BlankSlide()

    Dim navy As Long, navy2 As Long, teal As Long, tealDark As Long
    Dim gold As Long, white As Long, lightGray As Long, muted As Long
    navy = RGB(7, 14, 36)
    navy2 = RGB(14, 27, 58)
    teal = RGB(0, 210, 190)
    tealDark = RGB(0, 130, 125)
    gold = RGB(255, 194, 45)
    white = RGB(242, 246, 255)
    lightGray = RGB(190, 201, 225)
    muted = RGB(130, 148, 185)

    Dim sw As Single, sh As Single
    sw = pres.PageSetup.SlideWidth
    sh = pres.PageSetup.SlideHeight

    ' background
    Dim bg As Shape
    Set bg = sld.Shapes.AddShape(msoShapeRectangle, 0, 0, sw, sh)
    With bg
        .Fill.ForeColor.RGB = navy
        .Line.Visible = msoFalse
    End With

    ' left accent bar
    Dim accent As Shape
    Set accent = sld.Shapes.AddShape(msoShapeRectangle, 0, 0, sw * 0.012, sh)
    With accent
        .Fill.ForeColor.RGB = teal
        .Line.Visible = msoFalse
    End With

    ' subtle circuit network background
    AddCircuitBackground sld, sw, sh, teal

    ' top label
    AddTextBox sld, "COMPUTER NETWORKS  /  CYBERSECURITY", _
        sw * 0.06, sh * 0.075, sw * 0.48, sh * 0.045, _
        teal, 11, True, "Aptos", msoAlignLeft

    ' main title
    AddTextBox sld, "Advanced Encryption" & vbCrLf & "Standard", _
        sw * 0.06, sh * 0.145, sw * 0.53, sh * 0.22, _
        white, 34, True, "Aptos Display", msoAlignLeft

    ' AES badge
    Dim aesBadge As Shape
    Set aesBadge = sld.Shapes.AddShape(msoShapeRoundedRectangle, _
        sw * 0.06, sh * 0.405, sw * 0.13, sh * 0.065)
    With aesBadge
        .Fill.ForeColor.RGB = teal
        .Line.Visible = msoFalse
        .Adjustments.Item(1) = 0.25
    End With
    AddTextBox sld, "AES", sw * 0.06, sh * 0.407, sw * 0.13, sh * 0.06, _
        navy, 22, True, "Aptos Display", msoAlignCenter

    ' course
    AddTextBox sld, "CSE3006  " & DSH & "  Computer Networks", _
        sw * 0.06, sh * 0.505, sw * 0.43, sh * 0.055, _
        white, 18, True, "Aptos", msoAlignLeft

    ' faculty
    AddTextBox sld, "FACULTY", sw * 0.06, sh * 0.6, sw * 0.12, sh * 0.035, _
        gold, 10, True, "Aptos", msoAlignLeft
    AddTextBox sld, "Dr. S. Periyanayagi" & vbCrLf & "Senior Associate Professor / SCAI", _
        sw * 0.06, sh * 0.635, sw * 0.43, sh * 0.095, _
        lightGray, 13, False, "Aptos", msoAlignLeft

    ' class id / slot
    AddTextBox sld, "CLASS ID / SLOT", sw * 0.33, sh * 0.6, sw * 0.18, sh * 0.035, _
        gold, 10, True, "Aptos", msoAlignLeft
    AddTextBox sld, "BL2026270100338 / B11+B12+B13", _
        sw * 0.33, sh * 0.635, sw * 0.25, sh * 0.06, _
        lightGray, 11, False, "Aptos", msoAlignLeft

    ' group
    AddTextBox sld, "GROUP 06", sw * 0.06, sh * 0.79, sw * 0.15, sh * 0.04, _
        teal, 11, True, "Aptos", msoAlignLeft

    ' team members
    AddTextBox sld, "Shashi Singh   " & DOT & "   Vinit Burkul   " & DOT & _
        "   Chitrakavi Sai Chandana   " & DOT & "   Nandini Chooramani", _
        sw * 0.06, sh * 0.835, sw * 0.57, sh * 0.055, _
        lightGray, 10, False, "Aptos", msoAlignLeft

    ' right side AES security graphic
    AddAESGraphic sld, sw * 0.7, sh * 0.45, sw * 0.21, sh * 0.34, _
        teal, tealDark, gold, white, navy

    AddTextBox sld, "SECURE  " & DOT & "  ENCRYPT  " & DOT & "  TRANSMIT", _
        sw * 0.665, sh * 0.79, sw * 0.3, sh * 0.04, _
        muted, 9, True, "Aptos", msoAlignCenter

    ' bottom line
    Dim bottomLine As Shape
    Set bottomLine = sld.Shapes.AddShape(msoShapeRectangle, sw * 0.06, sh * 0.925, sw * 0.88, 1.5)
    With bottomLine
        .Fill.ForeColor.RGB = RGB(38, 55, 88)
        .Line.Visible = msoFalse
    End With

    ' footer
    AddTextBox sld, "CSE3006  |  GROUP 6", sw * 0.06, sh * 0.94, sw * 0.25, sh * 0.035, _
        muted, 8, False, "Aptos", msoAlignLeft
    AddTextBox sld, "01", sw * 0.91, sh * 0.94, sw * 0.035, sh * 0.035, _
        muted, 8, False, "Aptos", msoAlignRight
End Sub

Private Sub AddAESGraphic(ByVal sld As Slide, ByVal cx As Single, ByVal cy As Single, _
        ByVal w As Single, ByVal h As Single, ByVal teal As Long, ByVal tealDark As Long, _
        ByVal gold As Long, ByVal white As Long, ByVal navy As Long)

    Dim x As Single, y As Single
    x = cx - w / 2
    y = cy - h / 2

    ' outer hexagon
    Dim hx As Shape
    Set hx = sld.Shapes.AddShape(msoShapeHexagon, x - w * 0.14, y - h * 0.08, w * 1.28, h * 1.16)
    With hx
        .Fill.ForeColor.RGB = navy
        .Fill.Transparency = 0.2
        .Line.ForeColor.RGB = tealDark
        .Line.Weight = 1.5
        .Line.Transparency = 0.25
    End With

    ' circuit lines
    AddCircuitLine sld, x - w * 0.12, y + h * 0.15, x - w * 0.35, y + h * 0.02, tealDark
    AddCircuitLine sld, x + w * 1.12, y + h * 0.15, x + w * 1.35, y + h * 0.02, tealDark
    AddCircuitLine sld, x - w * 0.12, y + h * 0.82, x - w * 0.35, y + h * 0.96, tealDark
    AddCircuitLine sld, x + w * 1.12, y + h * 0.82, x + w * 1.35, y + h * 0.96, tealDark

    ' lock shackle
    Dim shackle As Shape
    Set shackle = sld.Shapes.AddShape(msoShapeArc, x + w * 0.3, y + h * 0.03, w * 0.4, h * 0.4)
    With shackle
        .Fill.Visible = msoFalse
        .Line.ForeColor.RGB = teal
        .Line.Weight = 8
    End With

    ' lock body
    Dim lockBody As Shape
    Set lockBody = sld.Shapes.AddShape(msoShapeRoundedRectangle, x + w * 0.2, y + h * 0.32, w * 0.6, h * 0.48)
    With lockBody
        .Fill.ForeColor.RGB = teal
        .Line.Visible = msoFalse
        .Adjustments.Item(1) = 0.18
    End With

    ' inner panel
    Dim inner As Shape
    Set inner = sld.Shapes.AddShape(msoShapeRoundedRectangle, x + w * 0.27, y + h * 0.39, w * 0.46, h * 0.34)
    With inner
        .Fill.ForeColor.RGB = navy
        .Line.ForeColor.RGB = tealDark
        .Line.Weight = 1
        .Adjustments.Item(1) = 0.15
    End With

    ' keyhole
    Dim keyCircle As Shape, keyStem As Shape
    Set keyCircle = sld.Shapes.AddShape(msoShapeOval, x + w * 0.455, y + h * 0.47, w * 0.09, w * 0.09)
    With keyCircle
        .Fill.ForeColor.RGB = gold
        .Line.Visible = msoFalse
    End With
    Set keyStem = sld.Shapes.AddShape(msoShapeRectangle, x + w * 0.475, y + h * 0.54, w * 0.05, h * 0.1)
    With keyStem
        .Fill.ForeColor.RGB = gold
        .Line.Visible = msoFalse
    End With

    ' AES text
    AddTextBox sld, "AES", x + w * 0.29, y + h * 0.66, w * 0.42, h * 0.08, _
        white, 15, True, "Aptos Display", msoAlignCenter

    ' data nodes
    AddNode sld, x - w * 0.25, y + h * 0.48, teal
    AddNode sld, x + w * 1.25, y + h * 0.48, teal
    AddNode sld, x + w * 0.1, y - h * 0.03, gold
    AddNode sld, x + w * 0.9, y - h * 0.03, gold
End Sub

Private Sub AddCircuitBackground(ByVal sld As Slide, ByVal sw As Single, ByVal sh As Single, ByVal teal As Long)
    Dim i As Long, ln As Shape
    For i = 0 To 4
        Set ln = sld.Shapes.AddConnector(msoConnectorStraight, sw * 0.015, sh * (0.12 + i * 0.18), _
            sw * (0.05 + i * 0.02), sh * (0.08 + i * 0.18))
        With ln
            .Line.ForeColor.RGB = teal
            .Line.Transparency = 0.88
            .Line.Weight = 1
        End With
    Next i
    For i = 0 To 4
        Set ln = sld.Shapes.AddConnector(msoConnectorStraight, sw * 0.93, sh * (0.12 + i * 0.18), _
            sw * 0.985, sh * (0.08 + i * 0.18))
        With ln
            .Line.ForeColor.RGB = teal
            .Line.Transparency = 0.88
            .Line.Weight = 1
        End With
    Next i
End Sub

Private Sub AddCircuitLine(ByVal sld As Slide, ByVal x1 As Single, ByVal y1 As Single, _
        ByVal x2 As Single, ByVal y2 As Single, ByVal clr As Long)
    Dim ln As Shape
    Set ln = sld.Shapes.AddConnector(msoConnectorStraight, x1, y1, x2, y2)
    With ln
        .Line.ForeColor.RGB = clr
        .Line.Weight = 1.5
        .Line.Transparency = 0.25
    End With
End Sub

Private Sub AddNode(ByVal sld As Slide, ByVal x As Single, ByVal y As Single, ByVal clr As Long)
    Dim nd As Shape
    Set nd = sld.Shapes.AddShape(msoShapeOval, x, y, 8, 8)
    With nd
        .Fill.ForeColor.RGB = clr
        .Line.Visible = msoFalse
    End With
End Sub

Private Function AddTextBox(ByVal sld As Slide, ByVal txt As String, ByVal l As Single, _
        ByVal t As Single, ByVal w As Single, ByVal h As Single, ByVal fontColor As Long, _
        ByVal fontSize As Single, ByVal isBold As Boolean, ByVal fontName As String, _
        ByVal alignment As MsoParagraphAlignment) As Shape
    Dim shp As Shape
    Set shp = sld.Shapes.AddTextbox(msoTextOrientationHorizontal, l, t, w, h)
    With shp
        .Fill.Visible = msoFalse
        .Line.Visible = msoFalse
        With .TextFrame2
            .TextRange.Text = txt
            .TextRange.Font.Name = fontName
            .TextRange.Font.Size = fontSize
            .TextRange.Font.Bold = isBold
            .TextRange.Font.Fill.ForeColor.RGB = fontColor
            .TextRange.ParagraphFormat.Alignment = alignment
            .VerticalAnchor = msoAnchorMiddle
            .MarginLeft = 0
            .MarginRight = 0
            .MarginTop = 0
            .MarginBottom = 0
        End With
    End With
    Set AddTextBox = shp
End Function

'==============================================================
' SLIDE 2 - TEAM
'==============================================================
Private Sub Slide02()
    Dim s As Slide, shp As Shape, data As Variant
    Set s = NewSlide("Group 6 " & DSH & " Team Members", "Team")

    ' ---- left: Name / Registration No. table ----
    data = Array( _
        Array("Name", "Registration No."), _
        Array("Shashi Singh", "24BAI10686"), _
        Array("Vinit Burkul", "24BAI10393"), _
        Array("Chitrakavi Sai Chandana", "23BHI10006"), _
        Array("Nandini Chooramani", "24BSA10119"))
    MakeTable s, data, 40, 130, 440, 300, 17

    ' ---- right: profile cards connected to a central AES node ----
    Line2 s, 600, 155, 710, 285, cTealD, 3
    Line2 s, 820, 155, 710, 285, cTealD, 3
    Line2 s, 600, 415, 710, 285, cTealD, 3
    Line2 s, 820, 415, 710, 285, cTealD, 3

    Set shp = Box(s, "AES", 645, 240, 130, 90, cAccent, cBG, 30, True, msoShapeOval)

    Set shp = Box(s, "Shashi Singh|24BAI10686", 505, 115, 190, 80, cPanel2, cText, 15)
    TwoLine shp, 15, 13, cAccent
    Set shp = Box(s, "Vinit Burkul|24BAI10393", 725, 115, 190, 80, cPanel2, cText, 15)
    TwoLine shp, 15, 13, cAccent
    Set shp = Box(s, "Chitrakavi Sai Chandana|23BHI10006", 505, 375, 190, 80, cPanel2, cText, 14)
    TwoLine shp, 14, 13, cAccent
    Set shp = Box(s, "Nandini Chooramani|24BSA10119", 725, 375, 190, 80, cPanel2, cText, 15)
    TwoLine shp, 15, 13, cAccent
End Sub

'==============================================================
' SLIDE 3 - INTRODUCTION
'==============================================================
Private Sub Slide03()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("What is AES?", "Introduction")
    Bullets s, Array( _
        "AES~ stands for Advanced Encryption Standard.", _
        "Type:~ a symmetric-key block cipher standardized by NIST.", _
        "Block size:~ data is encrypted in fixed 128-bit blocks.", _
        "Key sizes:~ 128-bit, 192-bit and 256-bit keys.", _
        "Origin:~ based on the Rijndael cipher, selected by NIST in 2000.", _
        "Standard:~ officially specified in FIPS 197 in 2001."), _
        40, 105, 570, 300, 18

    Set shp = Box(s, "Plaintext", 680, 112, 220, 44, cPanel2, cText, 18)
    Set shp = Box(s, "+ Secret Key", 680, 166, 220, 44, cAmber, cBG, 18)
    ArrowD s, 778, 216, 24, 22
    Set shp = Box(s, "AES", 680, 246, 220, 62, cAccent, cBG, 28)
    ArrowD s, 778, 314, 24, 22
    Set shp = Box(s, "Ciphertext", 680, 342, 220, 44, cPanel2, cText, 18)

    Set shp = Box(s, "Key idea:  Same secret key  =  Encryption + Decryption", 40, 425, 880, 58, _
                  cPanel, cAmber, 22)
End Sub

'==============================================================
' SLIDE 4 - NEED FOR ENCRYPTION
'==============================================================
Private Sub Slide04()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Why Do We Need Encryption?", "Motivation")
    Bullets s, Array( _
        "Network data can be intercepted while in transit.", _
        "Stored data can be accessed by unauthorized users.", _
        "Encryption converts readable plaintext into ciphertext.", _
        "Only a party with the correct key can recover the plaintext.", _
        "It helps protect the confidentiality of sensitive information.", _
        "Common targets: passwords, financial data, files and communications."), _
        40, 105, 540, 300, 16

    Set shp = Box(s, "Plaintext|PASSWORD = 123456", 620, 100, 300, 52, cPanel2, cText, 15)
    TwoLine shp, 12, 15, cAmber
    ArrowD s, 758, 156, 22, 20
    Set shp = Box(s, "Encryption", 620, 180, 300, 36, cAccent, cBG, 16)
    ArrowD s, 758, 220, 22, 20
    Set shp = Box(s, "Ciphertext|7F A2 91 ...", 620, 244, 300, 52, cPanel2, cText, 15)
    TwoLine shp, 12, 15, cAmber
    ArrowD s, 758, 300, 22, 20
    Set shp = Box(s, "Decryption", 620, 324, 300, 36, cAccent, cBG, 16)
    ArrowD s, 758, 364, 22, 20
    Set shp = Box(s, "Plaintext|PASSWORD = 123456", 620, 388, 300, 52, cPanel2, cText, 15)
    TwoLine shp, 12, 15, cAmber

    Set shp = Box(s, "Important distinction: encryption primarily provides confidentiality. " & _
                  "Authentication and integrity require additional mechanisms.", _
                  40, 420, 540, 72, cPanel, cAmber, 14, False)
End Sub

'==============================================================
' SLIDE 5 - EVOLUTION
'==============================================================
Private Sub Slide05()
    Dim s As Slide, shp As Shape, i As Long, xs As Variant, ys As Variant, nm As Variant
    Set s = NewSlide("DES " & ARW & " 3DES " & ARW & " AES", "Evolution of Encryption Standards")

    ' DES card
    Set shp = Box(s, "", 40, 100, 280, 250, cPanel, cText, 14)
    TB s, "DES " & DSH & " 1977", 52, 108, 260, 32, 20, cAmber, True
    Bullets s, Array("Standardized as FIPS 46.", "Used a 56-bit effective key.", _
        "Growing computing power made exhaustive key search practical.", _
        "Withdrawn by NIST in 2005."), 52, 148, 258, 195, 13

    ' 3DES card
    Set shp = Box(s, "", 340, 100, 280, 250, cPanel, cText, 14)
    TB s, "3DES / TDEA " & DSH & " 1999", 352, 108, 260, 32, 20, cAmber, True
    Bullets s, Array("Applies DES-based operations multiple times.", _
        "Introduced as a stronger transition from DES.", _
        "Included in FIPS 46-3 (1999)."), 352, 148, 258, 195, 13

    ' AES card
    Set shp = Box(s, "", 640, 100, 280, 250, cPanel, cText, 14)
    TB s, "AES " & DSH & " 2001", 652, 108, 260, 32, 20, cAmber, True
    Bullets s, Array("Based on the Rijndael cipher.", _
        "Designed for stronger security and better performance and flexibility.", _
        "Supports 128-, 192- and 256-bit keys."), 652, 148, 258, 195, 13

    ' timeline
    Line2 s, 80, 395, 880, 395, cMuted, 3
    xs = Array(190, 490, 790)
    ys = Array("1977", "1999", "2001")
    nm = Array("DES", "3DES / TDEA", "AES")
    For i = 0 To 2
        TB s, CStr(ys(i)), xs(i) - 60, 358, 120, 28, 20, cAmber, True, ppAlignCenter
        Set shp = s.Shapes.AddShape(msoShapeOval, xs(i) - 11, 384, 22, 22)
        shp.Fill.ForeColor.RGB = cAccent
        shp.Line.ForeColor.RGB = cBG
        shp.Line.Weight = 3
        TB s, CStr(nm(i)), xs(i) - 80, 410, 160, 26, 16, cText, True, ppAlignCenter
    Next i
    TB s, "Small key  " & ARW & "  stronger transition  " & ARW & "  modern symmetric standard", _
        40, 452, 880, 32, 20, cAccent, True, ppAlignCenter
End Sub

'==============================================================
' SLIDE 6 - WHY AES
'==============================================================
Private Sub Slide06()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Why AES?", "What makes AES different")
    Bullets s, Array( _
        "128-bit block size~ regardless of key size.", _
        "Three key lengths:~ 128, 192 and 256 bits.", _
        "Substitution" & DSH & "Permutation Network (SPN)~ structure.", _
        "Combines nonlinear substitution with byte-level permutation and mixing.", _
        "Designed for efficient implementation in software and hardware.", _
        "Substantially stronger security margins than legacy DES."), _
        40, 100, 880, 215, 16

    Set shp = Box(s, "Substitution|SubBytes", 40, 325, 250, 84, cPanel2, cText, 20)
    TwoLine shp, 22, 14, cAmber
    ArrowR s, 302, 355, 40, 26
    Set shp = Box(s, "Permutation|ShiftRows + MixColumns", 355, 325, 250, 84, cPanel2, cText, 20)
    TwoLine shp, 22, 14, cAmber
    ArrowR s, 617, 355, 40, 26
    Set shp = Box(s, "Key Mixing|AddRoundKey", 670, 325, 250, 84, cPanel2, cText, 20)
    TwoLine shp, 22, 14, cAmber

    Set shp = Box(s, "Design philosophy:  Substitution + Permutation + Key Mixing  " & ARW & _
                  "  Confusion + Diffusion", 40, 425, 880, 58, cAccent, cBG, 20)
End Sub

'==============================================================
' SLIDE 7 - SPECIFICATIONS
'==============================================================
Private Sub Slide07()
    Dim s As Slide, shp As Shape, data As Variant
    Set s = NewSlide("AES-128 vs AES-192 vs AES-256", "AES specifications")
    data = Array( _
        Array("Feature", "AES-128", "AES-192", "AES-256"), _
        Array("Block size", "128 bits", "128 bits", "128 bits"), _
        Array("Key size", "128 bits", "192 bits", "256 bits"), _
        Array("Key bytes", "16", "24", "32"), _
        Array("Rounds", "10", "12", "14"), _
        Array("State", "4 " & TMS & " 4 bytes", "4 " & TMS & " 4 bytes", "4 " & TMS & " 4 bytes"))
    MakeTable s, data, 40, 100, 880, 216, 16

    TB s, "Key size changes  " & ARW & "  number of rounds changes.   Block size remains 128 bits.", _
        40, 328, 880, 30, 18, cAmber, True, ppAlignCenter

    Set shp = Box(s, "AES-128|10 Rounds", 40, 375, 270, 110, cPanel2, cText, 22)
    TwoLine shp, 22, 34, cAccent
    Set shp = Box(s, "AES-192|12 Rounds", 345, 375, 270, 110, cPanel2, cText, 22)
    TwoLine shp, 22, 34, cAccent
    Set shp = Box(s, "AES-256|14 Rounds", 650, 375, 270, 110, cPanel2, cText, 22)
    TwoLine shp, 22, 34, cAccent
End Sub

'==============================================================
' SLIDE 8 - STATE MATRIX
'==============================================================
Private Sub Slide08()
    Dim s As Slide, shp As Shape, lab(0 To 15) As String, r As Long, c As Long
    Set s = NewSlide("The AES State", "State matrix")
    For r = 0 To 3
        For c = 0 To 3
            lab(r * 4 + c) = "a" & CStr(r + 4 * c)
        Next c
    Next r
    TB s, "4 " & TMS & " 4 State Matrix (16 bytes)", 50, 100, 360, 28, 16, cAmber, True, ppAlignCenter
    DrawGrid s, 50, 135, 90, 72, 4, 4, lab, 24, cPanel2, Rows4(cPanel2)
    TB s, "Input bytes fill the state column by column:" & vbCr & "a0 a1 a2 a3  |  a4 a5 a6 a7  |  ...", _
        50, 430, 400, 50, 13, cMuted, False, ppAlignCenter

    Bullets s, Array( _
        "One AES block~ = 128 bits = 16 bytes.", _
        "The bytes are arranged into a 4 " & TMS & " 4 state.", _
        "All AES transformations operate on this state.", _
        "The state is filled column-wise from the input block.", _
        "The state changes after each transformation."), _
        480, 120, 440, 330, 18
End Sub

'==============================================================
' SLIDE 9 - ENCRYPTION PROCESS
'==============================================================
Private Sub Slide09()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("AES Encryption Pipeline", "Encryption process")
    FlowRow s, 120, 190, Array( _
        "128-bit|Plaintext", _
        "Initial|AddRoundKey", _
        "AES Rounds||SubBytes|ShiftRows|MixColumns|AddRoundKey", _
        "Final Round||SubBytes|ShiftRows|AddRoundKey", _
        "Ciphertext"), _
        Array(cPanel2, cAmber, cTealD, cTealM, cPanel2), 15
    TB s, "repeated Nr " & MINUS & " 1 times", 404, 316, 152, 24, 12, cMuted, False, ppAlignCenter
    TB s, "Nr = 10, 12 or 14", 404, 336, 152, 24, 12, cMuted, False, ppAlignCenter
    Set shp = Box(s, "Important: the final round does not contain MixColumns." & vbCr & _
                  "This is one of the most important AES details to remember.", _
                  40, 395, 880, 80, cPanel, cAmber, 18)
    shp.TextFrame.TextRange.Paragraphs(2).Font.Size = 14
    shp.TextFrame.TextRange.Paragraphs(2).Font.Color.RGB = cText
    shp.TextFrame.TextRange.Paragraphs(2).Font.Bold = msoFalse
End Sub

'==============================================================
' SLIDE 10 - INITIAL ADDROUNDKEY
'==============================================================
Private Sub Slide10()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Step 1: Initial AddRoundKey", "Encryption begins")
    Bullets s, Array( _
        "AES begins by combining the plaintext state with the first round key.", _
        "The operation uses XOR.", _
        "Each state byte is XORed with the corresponding key byte.", _
        "The secret key enters the encryption process immediately.", _
        "No SubBytes, ShiftRows or MixColumns is performed before this step."), _
        40, 100, 440, 250, 15

    TB s, "Plaintext State", 500, 112, 112, 22, 11, cMuted, True, ppAlignCenter
    TB s, "Round Key", 642, 112, 112, 22, 11, cMuted, True, ppAlignCenter
    TB s, "New State", 780, 112, 112, 22, 11, cMuted, True, ppAlignCenter
    DrawGrid s, 500, 140, 28, 28, 4, 4, SeqLabels("p"), 9, cPanel2, Rows4(cPanel2)
    TB s, XORS, 612, 175, 30, 30, 20, cAmber, True, ppAlignCenter
    DrawGrid s, 642, 140, 28, 28, 4, 4, SeqLabels("k"), 9, cAmber, Rows4(cAmber)
    TB s, "=", 754, 175, 24, 30, 20, cAmber, True, ppAlignCenter
    DrawGrid s, 780, 140, 28, 28, 4, 4, SeqLabels("n"), 9, cTealM, Rows4(cTealM)

    CodeBox s, "    10101100" & vbCr & "XOR 01100101" & vbCr & "    --------" & vbCr & "    11001001", _
        40, 365, 420, 115, 18

    Set shp = Box(s, "State Byte", 490, 395, 120, 50, cPanel2, cText, 13)
    TB s, "XOR", 610, 405, 34, 30, 12, cAmber, True, ppAlignCenter
    Set shp = Box(s, "Round-Key Byte", 644, 395, 130, 50, cAmber, cBG, 13)
    ArrowR s, 778, 407, 26, 24
    Set shp = Box(s, "New State Byte", 808, 395, 112, 50, cTealM, cText, 13)
End Sub

'==============================================================
' SLIDE 11 - SUBBYTES
'==============================================================
Private Sub Slide11()
    Dim s As Slide, shp As Shape, r As Long, c As Long, f As Long
    Set s = NewSlide("SubBytes " & DSH & " Nonlinear Substitution", "Transformation 1")
    Bullets s, Array( _
        "Each byte in the state is replaced using the AES S-box.", _
        "The S-box provides nonlinearity.", _
        "Every byte is substituted independently.", _
        "The same S-box is used for all 16 state bytes.", _
        "The inverse S-box is used during decryption."), _
        40, 100, 580, 210, 16

    ' stylized 16 x 16 S-box
    For r = 0 To 15
        For c = 0 To 15
            If r = 5 And c = 3 Then
                f = cAmber
            ElseIf (r + c) Mod 2 = 0 Then
                f = cPanel2
            Else
                f = cPanel
            End If
            Set shp = s.Shapes.AddShape(msoShapeRectangle, 670 + c * 15.5, 108 + r * 15.5, 14, 14)
            shp.Fill.ForeColor.RGB = f
            shp.Line.Visible = msoFalse
        Next c
    Next r
    TB s, "Stylized 16 " & TMS & " 16 S-box" & vbCr & "(row 5, column 3 highlighted)", 650, 360, 290, 40, 11, cMuted, False, ppAlignCenter

    Set shp = Box(s, "Input Byte|53", 40, 330, 150, 64, cPanel2, cText, 16)
    TwoLine shp, 13, 20, cAmber
    ArrowR s, 200, 350, 34, 24
    Set shp = Box(s, "AES S-box", 244, 330, 170, 64, cAccent, cBG, 20)
    ArrowR s, 424, 350, 34, 24
    Set shp = Box(s, "Output Byte|ED", 468, 330, 150, 64, cPanel2, cText, 16)
    TwoLine shp, 13, 20, cAmber

    Set shp = Box(s, "Why? Nonlinear substitution makes relationships between plaintext, ciphertext " & _
                  "and key more difficult to exploit.", 40, 415, 580, 70, cPanel, cText, 14, False)
End Sub

'==============================================================
' SLIDE 12 - SHIFTROWS
'==============================================================
Private Sub Slide12()
    Dim s As Slide, shp As Shape, rc As Variant, i As Long, lr As Variant
    Set s = NewSlide("ShiftRows " & DSH & " Permuting the State", "Transformation 2")
    rc = Array(cPanel2, RGB(31, 92, 140), RGB(116, 72, 150), RGB(160, 92, 40))

    TB s, "Before", 40, 100, 224, 26, 16, cAmber, True, ppAlignCenter
    DrawGrid s, 40, 130, 56, 48, 4, 4, Array("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", _
        "M", "N", "O", "P"), 18, cPanel2, rc
    ArrowR s, 272, 212, 42, 28
    TB s, "After", 330, 100, 224, 26, 16, cAmber, True, ppAlignCenter
    DrawGrid s, 330, 130, 56, 48, 4, 4, Array("A", "B", "C", "D", "F", "G", "H", "E", "K", "L", "I", "J", _
        "P", "M", "N", "O"), 18, cPanel2, rc
    lr = Array("no shift", "left 1", "left 2", "left 3")
    For i = 0 To 3
        TB s, CStr(lr(i)), 558, 130 + i * 48 + 10, 80, 24, 12, cMuted
    Next i

    TB s, "Rules", 660, 100, 260, 26, 16, cAmber, True
    Bullets s, Array("Row 0:~ no shift", "Row 1:~ shift left by 1 byte", "Row 2:~ shift left by 2 bytes", _
        "Row 3:~ shift left by 3 bytes"), 660, 130, 260, 200, 15

    TB s, "Purpose", 40, 345, 300, 26, 16, cAmber, True
    Bullets s, Array("Rearranges bytes between columns.", _
        "Helps spread the effect of substitutions across the state.", _
        "Contributes to diffusion."), 40, 375, 880, 110, 16
End Sub

'==============================================================
' SLIDE 13 - MIXCOLUMNS
'==============================================================
Private Sub Slide13()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("MixColumns " & DSH & " Mixing Each Column", "Transformation 3")
    Bullets s, Array( _
        "Each column is transformed independently.", _
        "The four bytes of a column are mathematically combined.", _
        "The operation is performed over GF(2" & Sup("8") & ").", _
        "It provides strong diffusion across each column.", _
        "A change in one byte influences multiple output bytes."), _
        40, 100, 470, 280, 16

    TB s, "Conceptual matrix multiplication", 535, 100, 380, 26, 15, cAmber, True, ppAlignCenter
    DrawGrid s, 535, 145, 44, 44, 4, 4, Array("02", "03", "01", "01", "01", "02", "03", "01", _
        "01", "01", "02", "03", "03", "01", "01", "02"), 15, cPanel2, Rows4(cPanel2)
    TB s, TMS, 713, 220, 34, 34, 22, cAmber, True, ppAlignCenter
    DrawGrid s, 748, 145, 44, 44, 4, 1, Array("a", "b", "c", "d"), 15, cTealD, Rows4(cTealD)
    TB s, "=", 794, 220, 30, 34, 22, cAmber, True, ppAlignCenter
    DrawGrid s, 826, 145, 44, 44, 4, 1, Array("a'", "b'", "c'", "d'"), 15, cTealM, Rows4(cTealM)
    TB s, "Column [A B C D]  " & ARW & "  MixColumns  " & ARW & "  [A' B' C' D']", _
        535, 335, 385, 28, 14, cMuted, False, ppAlignCenter

    Set shp = Box(s, "Important: MixColumns is used in the main rounds, but not in the final round.", _
                  40, 410, 880, 62, cPanel, cAmber, 18)
End Sub

'==============================================================
' SLIDE 14 - ADDROUNDKEY
'==============================================================
Private Sub Slide14()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("AddRoundKey " & DSH & " Key Mixing", "Transformation 4")
    Bullets s, Array( _
        "The current state is combined with a round key.", _
        "The operation is a byte-wise XOR.", _
        "Each AES round uses a different round key.", _
        "Round keys are generated from the original key by the key schedule.", _
        "This is where the secret key directly influences the round state."), _
        40, 100, 540, 270, 16

    Set shp = Box(s, "State", 640, 105, 270, 50, cPanel2, cText, 18)
    TB s, "XOR", 640, 158, 270, 28, 18, cAmber, True, ppAlignCenter
    Set shp = Box(s, "Round Key", 640, 190, 270, 50, cAmber, cBG, 18)
    ArrowD s, 752, 246, 26, 24
    Set shp = Box(s, "Updated State", 640, 276, 270, 50, cTealM, cText, 18)

    Set shp = Box(s, "Important property:|XOR is reversible", 40, 385, 420, 80, cPanel, cAmber, 20)
    TwoLine shp, 14, 22, cAmber
    shp.TextFrame.TextRange.Paragraphs(1).Font.Color.RGB = cMuted
    CodeBox s, "A XOR K XOR K = A", 480, 385, 440, 80, 26
    TB s, "This property is useful during decryption.", 480, 470, 440, 24, 13, cMuted, False, ppAlignCenter
End Sub

'==============================================================
' SLIDE 15 - ROUND STRUCTURE
'==============================================================
Private Sub Slide15()
    Dim s As Slide, shp As Shape, i As Long, nm As Variant
    Set s = NewSlide("Inside an AES Round", "Round structure")

    TB s, "Standard round", 50, 100, 260, 28, 18, cAccent, True, ppAlignCenter
    nm = Array("SubBytes", "ShiftRows", "MixColumns", "AddRoundKey")
    For i = 0 To 3
        Set shp = Box(s, CStr(nm(i)), 50, 135 + i * 62, 260, 44, IIf(i = 2, cAmber, cPanel2), cText, 16)
        If i < 3 Then ArrowD s, 168, 135 + i * 62 + 46, 24, 14
    Next i
    TB s, "(repeated Nr " & MINUS & " 1 times)", 50, 384, 260, 22, 12, cMuted, False, ppAlignCenter

    TB s, "Final round", 350, 100, 260, 28, 18, cAccent, True, ppAlignCenter
    nm = Array("SubBytes", "ShiftRows", "AddRoundKey")
    For i = 0 To 2
        Set shp = Box(s, CStr(nm(i)), 350, 135 + i * 62, 260, 44, cPanel2, cText, 16)
        If i < 2 Then ArrowD s, 468, 135 + i * 62 + 46, 24, 14
    Next i
    TB s, "no MixColumns", 350, 322, 260, 22, 12, cAmber, True, ppAlignCenter

    TB s, "Round count", 650, 100, 270, 28, 18, cAccent, True, ppAlignCenter
    Set shp = Box(s, "AES-128 " & ARW & " 10 rounds", 650, 135, 270, 56, cTealD, cText, 17)
    Set shp = Box(s, "AES-192 " & ARW & " 12 rounds", 650, 205, 270, 56, cTealM, cText, 17)
    Set shp = Box(s, "AES-256 " & ARW & " 14 rounds", 650, 275, 270, 56, cAccent, cBG, 17)

    Set shp = Box(s, "Key takeaway: MixColumns is intentionally omitted from the final round.", _
                  40, 425, 880, 58, cPanel, cAmber, 20)
End Sub

'==============================================================
' SLIDE 16 - KEY EXPANSION
'==============================================================
Private Sub Slide16()
    Dim s As Slide, shp As Shape, i As Long, nm As Variant, yy As Single
    Set s = NewSlide("How Are Round Keys Generated?", "Key expansion / key schedule")
    Bullets s, Array( _
        "AES does not use the original key unchanged in every round.", _
        "The original key is expanded into a sequence of round keys.", _
        "This process is called Key Expansion (the Key Schedule).", _
        "It uses operations such as RotWord, SubWord and Rcon.", _
        "Each round receives its corresponding derived round key.", _
        "Longer AES keys require more expanded key material."), _
        40, 100, 880, 190, 16

    ' branch lines first (behind boxes)
    For i = 0 To 3
        Line2 s, 450, 393, 560, 318 + i * 50, cTealD, 2.5
    Next i

    Set shp = Box(s, "Cipher Key", 40, 358, 150, 70, cAmber, cBG, 18)
    ArrowR s, 198, 381, 44, 26
    Set shp = Box(s, "Key Expansion", 250, 358, 200, 70, cAccent, cBG, 18)

    nm = Array("Round Key 0", "Round Key 1", "Round Key 2", "...  Final Round Key")
    For i = 0 To 3
        Set shp = Box(s, CStr(nm(i)), 560, 300 + i * 50, 240, 36, cPanel2, cText, 15)
    Next i

    TB s, "Technical note: the exact expansion differs between AES-128, AES-192 and AES-256.", _
        40, 445, 500, 40, 12, cAmber
End Sub

'==============================================================
' SLIDE 17 - DECRYPTION
'==============================================================
Private Sub Slide17()
    Dim s As Slide, shp As Shape, i As Long, nm As Variant
    Set s = NewSlide("AES Decryption", "Reversing the process")
    TB s, "Decryption reverses the encryption transformations using their inverse operations.", _
        40, 98, 880, 28, 15, cText

    nm = Array("InvShiftRows", "InvSubBytes", "AddRoundKey", "InvMixColumns")
    For i = 0 To 3
        Set shp = Box(s, CStr(nm(i)), 40 + i * 225, 134, 205, 40, IIf(i = 2, cAmber, cPanel2), cText, 16)
    Next i

    FlowRow s, 195, 175, Array( _
        "Ciphertext", _
        "AddRoundKey", _
        "Inverse Rounds||InvShiftRows|InvSubBytes|AddRoundKey|InvMixColumns", _
        "Final Inverse Round||InvShiftRows|InvSubBytes|AddRoundKey", _
        "Plaintext"), _
        Array(cPanel2, cAmber, cTealD, cTealM, cPanel2), 14

    Bullets s, Array( _
        "Decryption uses the same secret key.", _
        "Round keys are used in reverse order.", _
        "In the final inverse round, InvMixColumns is omitted."), _
        40, 395, 880, 100, 17
End Sub

'==============================================================
' SLIDE 18 - SECURITY
'==============================================================
Private Sub Slide18()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("How Secure Is AES?", "Security")
    Bullets s, Array( _
        "AES has been extensively studied by the cryptographic community.", _
        "No practical attack is known that recovers AES keys faster than brute-force search in the general case.", _
        "Larger keys give larger key-search spaces: AES-256 > AES-128 (classically).", _
        "Security also depends on correct implementation, key management and mode of operation.", _
        "AES should not be described as 'unbreakable'."), _
        40, 100, 530, 300, 15

    TB s, "Security hierarchy", 610, 100, 310, 26, 16, cAmber, True, ppAlignCenter
    Set shp = Box(s, "AES-128|2" & Sup("128") & " possible keys", 610, 132, 310, 64, cPanel2, cText, 20)
    TwoLine shp, 20, 16, cAmber
    Set shp = Box(s, "AES-192|2" & Sup("192") & " possible keys", 610, 206, 310, 64, cTealD, cText, 20)
    TwoLine shp, 20, 16, cAmber
    Set shp = Box(s, "AES-256|2" & Sup("256") & " possible keys", 610, 280, 310, 64, cTealM, cText, 20)
    TwoLine shp, 20, 16, cAmber

    Set shp = Box(s, "A strong cipher does not compensate for:  weak passwords + leaked keys + " & _
                  "implementation vulnerabilities", 40, 405, 880, 54, cPanel, cAmber, 17)
    TB s, "NIST continues to regard AES as an important symmetric primitive in post-quantum planning.", _
        40, 466, 880, 28, 12, cMuted, False, ppAlignCenter
End Sub

'==============================================================
' SLIDE 19 - APPLICATIONS
'==============================================================
Private Sub Slide19()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Where Is AES Used Today?", "Applications and recent trends")

    Set shp = Box(s, "", 40, 100, 430, 290, cPanel, cText, 12)
    TB s, "Applications", 54, 106, 400, 30, 19, cAmber, True
    Bullets s, Array( _
        "TLS/HTTPS~ protects network communications.", _
        "Wi-Fi security~ AES-based modes such as CCMP/AES.", _
        "VPNs~ protect tunneled network traffic.", _
        "Disk/storage encryption~ modes such as XTS-AES.", _
        "Cloud and file encryption~ protects stored data.", _
        "Mobile and IoT~ protects sensitive device data."), _
        54, 142, 405, 240, 13

    Set shp = Box(s, "", 490, 100, 430, 290, cPanel, cText, 12)
    TB s, "Recent trends", 504, 106, 400, 30, 19, cAmber, True
    Bullets s, Array( _
        "AES-GCM~ provides authenticated encryption with associated data.", _
        "AES-NI~ and similar hardware instructions accelerate AES operations.", _
        "Post-quantum planning~ continues to examine the security of symmetric cryptography.", _
        "AES remains an important building block alongside newer post-quantum public-key algorithms."), _
        504, 142, 405, 240, 13

    Set shp = Box(s, "Critical distinction" & vbCr & "AES  =  encryption primitive" & vbCr & _
                  "AES-GCM  =  authenticated-encryption mode using AES", 40, 405, 880, 88, cPanel2, cText, 19)
    With shp.TextFrame.TextRange
        .Paragraphs(1).Font.Size = 12
        .Paragraphs(1).Font.Color.RGB = cMuted
        .Paragraphs(2).Font.Color.RGB = cAccent
        .Paragraphs(3).Font.Color.RGB = cAmber
    End With
End Sub

'==============================================================
' SLIDE 20 - ADVANTAGES / LIMITATIONS
'==============================================================
Private Sub Slide20()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Advantages vs Limitations", "Evaluation")

    Set shp = Box(s, "", 40, 100, 430, 305, cPanel, cText, 12)
    TB s, "Advantages", 54, 106, 400, 30, 19, cGreen, True
    Bullets s, Array( _
        "Strong security with 128/192/256-bit keys.", _
        "Efficient in software and hardware.", _
        "Widely standardized and extensively analyzed.", _
        "Supports multiple modes of operation.", _
        "Suitable for systems from servers to embedded devices.", _
        "Hardware acceleration can provide high performance."), _
        54, 142, 405, 255, 14

    Set shp = Box(s, "", 490, 100, 430, 305, cPanel, cText, 12)
    TB s, "Limitations", 504, 106, 400, 30, 19, cRed, True
    Bullets s, Array( _
        "AES alone provides confidentiality, not complete security.", _
        "Requires secure key management.", _
        "Incorrect modes or nonce/IV handling can create serious vulnerabilities.", _
        "AES does not inherently provide authentication or integrity.", _
        "Security depends on correct implementation and system design."), _
        504, 142, 405, 255, 14

    Set shp = Box(s, "Bottom line:  Strong algorithm  " & NEQ & "  automatically secure system", _
                  40, 422, 880, 60, cAccent, cBG, 22)
End Sub

'==============================================================
' SLIDE 21 - CONCLUSION
'==============================================================
Private Sub Slide21()
    Dim s As Slide, shp As Shape
    Set s = NewSlide("Conclusion", "Summary")
    Bullets s, Array( _
        "AES is a symmetric-key block cipher standardized by NIST.", _
        "It operates on 128-bit blocks with 128-, 192- or 256-bit keys.", _
        "Core transformations:~ SubBytes, ShiftRows, MixColumns and AddRoundKey.", _
        "AES uses 10, 12 or 14 rounds, depending on key size.", _
        "The final encryption round omits MixColumns.", _
        "AES remains a fundamental building block for modern data protection.", _
        "Secure deployment also needs authenticated modes, proper key management and correct implementation."), _
        40, 100, 880, 295, 16

    Set shp = Box(s, "AES provides the cryptographic engine " & DSH & " secure system design determines " & _
                  "how safely that engine is used.", 40, 410, 880, 80, cPanel2, cAmber, 20)
End Sub

'==============================================================
' SLIDE 22 - REFERENCES
'==============================================================
Private Sub Slide22()
    Dim s As Slide, shp As Shape, items As Variant, i As Long, txt As String, isH As Boolean
    Set s = NewSlide("References", "Sources")
    items = Array( _
        "#Primary Standards", _
        "[1] National Institute of Standards and Technology (NIST), FIPS 197: Advanced Encryption Standard (AES), Updated Edition, 2023.  https://csrc.nist.gov/pubs/fips/197/final", _
        "[2] Morris Dworkin, NIST, SP 800-38D: Recommendation for Block Cipher Modes of Operation: Galois/Counter Mode (GCM) and GMAC, 2007.  https://csrc.nist.gov/pubs/sp/800/38/d/final", _
        "[3] NIST, Report on the Development of the Advanced Encryption Standard (AES), 2001.", _
        "#Historical Standards", _
        "[4] NIST, FIPS 46-3: Data Encryption Standard (DES), 1999.", _
        "[5] NIST, FIPS 46: Data Encryption Standard (DES), 1977.", _
        "#Textbooks", _
        "[6] William Stallings, Cryptography and Network Security: Principles and Practice, Pearson.", _
        "[7] Behrouz A. Forouzan, Data Communications and Networking, McGraw-Hill.")

    For i = 0 To UBound(items)
        If Left$(items(i), 1) = "#" Then
            txt = txt & Mid$(items(i), 2)
        Else
            txt = txt & items(i)
        End If
        If i < UBound(items) Then txt = txt & vbCr
    Next i

    Set shp = TB(s, txt, 40, 100, 880, 395, 13, cText)
    With shp.TextFrame.TextRange.ParagraphFormat
        .LineRuleAfter = msoFalse
        .SpaceAfter = 6
    End With
    For i = 0 To UBound(items)
        If Left$(items(i), 1) = "#" Then
            With shp.TextFrame.TextRange.Paragraphs(i + 1)
                .Font.Bold = msoTrue
                .Font.Size = 17
                .Font.Color.RGB = cAmber
            End With
        End If
    Next i
End Sub
