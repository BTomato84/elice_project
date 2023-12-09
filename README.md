# Elice Project

## Architecture

### 개요

MVC를 기반으로 하여, Section단위로 로직과 렌더링 로직을 분리하여 구동한다.

ViewController 대신 SectionContoller가 배치되며, SectionInteractor가 비지니스 로직을 담당하게 된다.

View의 라이프 사이클과 RenderingData는 ItemMeta가 담당하여 구동하게 된다.

Section에 대한 로직을 최대한 Section내부에서 처리하게 하여 ViewController의 로직 복잡도를 감소시키고 섹션단위의 재사용성을 높인다.

### SC

Section을 Control하는 Controller
Cell의 LifeCycle관리 및 SectionLayout, Cell의 렌더링 데이터를 관리한다.

```func head() -> (any ItemMetaProtocol)?``` : 섹션의 header를 그리기 위한 메타 데이터를 제공한다.

```func body() -> [any ItemMetaProtocol]``` : 실제 섹션의 아이템들을 그리기 위한 메타 데이터들을 제공한다.

```func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?``` : 섹션의 레이아웃 정보를 제공한다.

### SectionInteractor

Section에서 사용하는 Data와 통신을 관리한다.

```func refresh()``` : 필요할 시 섹션의 재렌더링을 요구한다.

### ItemMeta

셀을 그리기 위한 데이터. 셀의 렌더링 데이터와 셀의 타입, 셀을 눌렀을 시 이벤트를 관리한다.

```init(reuseIdentifier: String? = nil, rm: WV.RM, selected: @escaping (() -> Void) = { })```
- reuseIdentifier : 재생성 사용자. 지정하지 않으면 CellType을 사용한다.
- rm : 셀을 그리기 위한 렌더링 모델
- selected : 선택하였을 시의 이벤트

### SectionListViewController

SectionController 시스템을 구동하기 위한 ViewController.

```var sections: [SectionController]``` : UICollectionView에 그리기 위한 섹션 데이터

## RenderingData

### 개요

최대한 비지니스 로직 및 비지니스 적인 용어를 제거한 RenderingData를 목적으로 한다.

각 UIView, UILabel, UIImageView, UIButton에 대한 RenderingData를 처리한다.

### ViewRenderingData

- backgroundColor : UIView의 배경색
- borderWidth : UIView의 border라인의 굵기
- borderColor : UIView의 border라인의 색상
- cornerRadius : UIView의 가장자리의 곡률
- contentMode : UIView의 컨텐트 모드
- isHidden : UIView의 히든 여부

### LabelRenderingData

- font : UILabel의 폰트
- text : UILabel에 표시할 텍스트
- attributedString : UILabel에 표시할 NSAttributedString
- color : UILabel의 텍스트 컬러
- textAlign : UILabel의 TextAlignment
- numberOfLines : UILabel에 표시될 최대 텍스트 줄 수
- view : UILabel에 적용할 UIView 속성

### ImageRenderingData

- imageName : UIImageView에 표시할 bundle Image Name
- imageURL : UIImageView에 불러올 url
- view : UIImageView에 적용할 UIView 속성

### ButtonRenderingData

- buttonImageName : UIButton에 표시할 bundle Image Name
- buttonTitle : UIButton애 표시할 텍스트
- titleFont : UIButton에 표시할 텍스트의 폰트
- titleColor : UIButton에 표시할 텍스트의 컬러
- view : UIButton에 적용할 UIView 속성