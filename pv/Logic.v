Require Import Coq.Logic.Classical_Prop.
Require Import Coq.Setoids.Setoid.
Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Psatz.
Require Import PV.Intro.
Require Import PV.SimpleProofsAndDefs.
Local Open Scope Z.

(** 数学中可以用“并且”、“或”、“非”、“如果-那么”、“存在”以及“任意”把简单性质组合起来构
    成复杂性质或复杂命题，例如“单调且连续”与“无限且不循环”这两个常用数学概念的定义中就
    用到了逻辑连接词“并且”，又例如“有零点”这一数学概念的定义就要用到“存在”这个逻辑中的
    量词（quantifier）。Coq中也允许用户使用这些常用的逻辑符号。

    下面是一个使用逻辑符号定义复合命题的例子。我们先如下定义“下凸函数”（_[convex]_）。*)

Definition convex (f: Z -> Z): Prop :=
  forall x: Z, f (x - 1) + f (x + 1) >= 2 * f x.

(** 之后，我们就可以用_[mono f /\ convex f]_表示函数_[f]_是一个单调下凸函数。

    下面性质说的是，如果一个函数变换_[T]_能保持单调性，也能保持凸性，那么它也能保持“单
    调下凸”这个性质。*)

Fact logic_ex1: forall T: (Z -> Z) -> (Z -> Z),
  (forall f, mono f -> mono (T f)) ->
  (forall f, convex f -> convex (T f)) ->
  (forall f, mono f /\ convex f -> mono (T f) /\ convex (T f)).

(** 不难发现，这一性质的证明与单调性的定义无关，也和凸性的定义无关，这一性质的证明只需
    用到其中各个逻辑符号的性质。下面是Coq证明。*)

Proof.
  intros.
  (** 在_[intros]_指令执行后，Coq证明目标中共有三条前提：
      - H: forall f, mono f -> mono (T f)
      - H0: forall f, convex f -> convex (T f)
      - H1: mono f /\ convex f *)
  pose proof H f.
  (** 获得一个新的前提
      - H2: mono f -> mono (T f) *)
  pose proof H0 f.
  (** 获得一个新的前提
      - H3: convex f -> convex (T f) *)
  tauto.
Qed.

(** 最后一条证明指令_[tauto]_是英文单词“tautology”的缩写，表示当前证明目标是一个命题
    逻辑永真式，可以自动证明。在上面证明中，如果把命题_[mono f]_与_[convex f]_记作命
    题_[P1]_与_[Q1]_，将命题_[mono (T f)]_看作一个整体记作_[P2]_，将命题
    _[convex (T f)]_也看作一个整体记为_[Q2]_，那么证明指令_[tauto]_在此处证明的结论
    就可以概括为：如果

        _[P1]_成立并且_[Q1]_成立（前提_[H1]_）

        _[P1]_能推出_[P2]_（前提_[H2]_） 

        _[Q1]_能推出_[Q2]_（前提_[H3]_） 

    那么_[P2]_成立并且_[Q2]_成立。不难看出，无论_[P1]_、_[Q1]_、_[P2]_与_[Q2]_这四
    个命题中的每一个是真是假，上述推导都成立。因此，这一推导过程可以用一个命题逻辑永真
    式刻画，_[tauto]_能够自动完成它的证明。Coq中也可以把这一原理单独地表述出来：*)

Fact logic_ex2: forall P1 Q1 P2 Q2: Prop,
  P1 /\ Q1 ->
  (P1 -> P2) ->
  (Q1 -> Q2) ->
  P2 /\ Q2.
Proof.
  intros P1 Q1 P2 Q2 H1 H2 H3.
  tauto.
Qed.

(** 仅仅利用_[tauto]_指令就已经能够证明不少关于逻辑的结论了。下面两个例子刻画了一个命
    题与其逆否命题的关系。*)

Fact logic_ex3: forall {A: Type} (P Q: A -> Prop),
  (forall a: A, P a -> Q a) ->
  (forall a: A, ~ Q a -> ~ P a).
Proof. intros A P Q H a. pose proof H a. tauto. Qed.

Fact logic_ex4: forall {A: Type} (P Q: A -> Prop),
  (forall a: A, ~ Q a -> ~ P a) ->
  (forall a: A, P a -> Q a).
Proof. intros A P Q H a. pose proof H a. tauto. Qed.

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面结论。*)

Fact logic_ex5: forall {A: Type} (P Q: A -> Prop),
  (forall a: A, P a -> Q a) ->
  (forall a: A, P a) ->
  (forall a: A, Q a).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面结论。*)

Fact logic_ex6: forall {A: Type} (P Q: A -> Prop) (a0: A),
  P a0 ->
  (forall a: A, P a -> Q a) ->
  Q a0.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面结论。*)

Fact logic_ex7: forall {A: Type} (P Q: A -> Prop) (a0: A),
  (forall a: A, P a -> Q a -> False) ->
  Q a0 -> 
  ~ P a0.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面结论。*)

Fact logic_ex8: forall {A B: Type} (P Q: A -> B -> Prop),
  (forall (a: A) (b: B), P a b -> Q a b) ->
  (forall (a: A) (b: B), ~ P a b \/ Q a b).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面结论。*)

Fact logic_ex9: forall {A B: Type} (P Q: A -> B -> Prop),
  (forall (a: A) (b: B), ~ P a b \/ Q a b) ->
  (forall (a: A) (b: B), P a b -> Q a b).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)


(** 尽管_[tauto]_指令利用命题逻辑永真式已经能够证明不少逻辑性质，但有些时候，我们需要
    对包含逻辑符号的命题进行更细粒度的操作才能完成Coq证明。本章的后续各节将展开介绍这些
    Coq中的证明方法。*)

(** * 关于“并且”的证明 *)

(** 要证明“某命题甲并且某命题乙”成立，可以在Coq中使用_[split]_证明指令进行证明。该
    指令会将当前的证明目标拆成两个子目标。*)

Lemma and_intro: forall A B: Prop, A -> B -> A /\ B.
Proof.
  intros A B HA HB.
  (** 拆分前，需要证明的结论是_[A /\ B]_ *)
  split.
  + (** 第一个分支的待证明结论是_[A]_ *)
    apply HA.
    (** 上面的_[apply]_指令表示在证明中使用一条前提，或者使用一条已经经过证明的
        定理或引理。*)
  + (** 第二个分支的待证明结论是_[B]_ *)
    apply HB.
Qed.

(** 如果当前一条前提假设具有“某命题甲并且某命题乙”的形式，我们可以在Coq中使用
    _[destruct]_指令将其拆分成为两个前提。 *)

Lemma proj1: forall P Q: Prop,
  P /\ Q -> P.
Proof.
  intros.
  (** 拆分前，当前证明目标有一个前提
      - H: P /\ Q *)
  destruct H as [HP HQ].
  (** 拆分后，当前证明目标有两个前提
      - HP: P
      - HQ: Q *)
  apply HP.
Qed.

(** 另外，_[destruct]_指令也可以不指名拆分后的前提的名字，Coq会自动命名。*)

Lemma proj2: forall P Q: Prop,
  P /\ Q -> Q.
Proof.
  intros.
  destruct H.
  (** 拆分后，当前证明目标有两个前提
      - H: P
      - H0: Q *)
  apply H0.
Qed.

(** 当前提与结论中，都有_[/\]_的时候，我们就既需要使用_[split]_指令，又需要使用
    _[destruct]_指令。*)

Theorem and_comm: forall P Q: Prop,
  P /\ Q -> Q /\ P.
Proof.
  intros.
  destruct H as [HP HQ].
  split.
  + apply HQ.
  + apply HP.
Qed.

(************)
(** 习题：  *)
(************)

(** 请在不使用_[tauto]_指令的情况下证明下面结论。*)

Theorem and_assoc1: forall P Q R: Prop,
  P /\ (Q /\ R) -> (P /\ Q) /\ R.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

Theorem and_assoc2: forall P Q R: Prop,
  (P /\ Q) /\ R -> P /\ (Q /\ R).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(** * 关于“或”的证明 *)

(** “或”是另一个重要的逻辑连接词。如果“或”出现在前提中，我们可以用Coq中的
    _[destruct]_指令进行分类讨论。在下面的例子中，我们对于前提_[P \/ Q]_进行分类讨
    论。要证明_[P \/ Q]_能推出原结论，就需要证明_[P]_与_[Q]_中的任意一个都可以推出原
    结论。*)

Fact or_example:
  forall P Q R: Prop, (P -> R) -> (Q -> R) -> (P \/ Q -> R).
Proof.
  intros.
  (** 拆分前，Coq证明目标中有三个前提：
      - H: P -> R
      - H0: Q -> R
      - H1: P \/ Q
      待证明结论是_[R]_。下面的_[destruct]_指令对_[H1]_分类讨论。 *)
  destruct H1 as [HP | HQ].
  + (** 第一种情况，_[P]_成立（前提_[HP]_） *)
    pose proof H HP.
    apply H1.
  + (** 第一种情况，_[Q]_成立（前提_[HQ]_） *)
    pose proof H0 HQ.
    apply H1.
Qed.

(** 相反的，如果要证明一条形如_[A \/ B]_的结论整理，我们就只需要证明_[A]_与_[B]_
    两者之一成立就可以了。在Coq中的指令是：_[left]_与_[right]_。例如，下面是选择
    左侧命题的例子。*)

Lemma or_introl: forall A B: Prop, A -> A \/ B.
Proof.
  intros.
  (** 选择前，要证明的结论是_[A \/ B]_。 *)
  left.
  (** 选择左侧后，要证明的结论是_[A]_。 *)
  apply H.
Qed.

(** 下面是选择右侧命题的例子。*)

Lemma or_intror: forall A B: Prop, B -> A \/ B.
Proof.
  intros.
  (** 选择前，要证明的结论是_[A \/ B]_。 *)
  right.
  (** 选择右侧后，要证明的结论是_[B]_。 *)
  apply H.
Qed.

(************)
(** 习题：  *)
(************)

(** 请在不使用_[tauto]_指令的情况下证明下面结论。*)

Theorem or_comm: forall P Q: Prop,
  P \/ Q  -> Q \/ P.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在不使用_[tauto]_指令的情况下证明下面结论。*)

Theorem or_assoc1: forall P Q R: Prop,
  P \/ (Q \/ R)  -> (P \/ Q) \/ R.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

Theorem or_assoc2: forall P Q R: Prop,
  (P \/ Q) \/ R -> P \/ (Q \/ R).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(** * 关于“当且仅当”的证明 *)

(** 在Coq中，_[<->]_符号对应的定义是_[iff]_，其将_[P <-> Q]_定义为 

        _[(P -> Q) /\ (Q -> P)]_ 

    因此，要证明关于“当且仅当”的性质，首先可以使用其定义进行证明。*)

Theorem iff_refl: forall P: Prop, P <-> P.
Proof.
  intros.
  (** 展开前，待证明的目标是_[P <-> P]_ *)
  unfold iff.
  (** 展开后，待证明的目标是_[(P -> P) /\ (P -> P)]_ *)
  split.
  + (** 第一个分支需要证明_[P -> P]_ *)
    intros.
    apply H.
  + (** 第二个分支也需要证明_[P -> P]_ *)
    intros.
    apply H.
Qed.

(** Coq也允许在不展开“当且仅当”的定义时就使用_[split]_或_[destruct]_指令进行证明。*)

Theorem and_dup: forall P: Prop, P /\ P <-> P.
Proof.
  intros.
  (** 拆分前，待证明的目标是_[P /\ P <-> P]_ *)
  split.
  + (** 拆分后，第一个分支需要证明_[P /\ P -> P]_ *)
    intros.
    destruct H.
    apply H.
  + (** 拆分后，第二个分支需要证明_[P -> P /\ P]_ *)
    intros.
    split.
    - apply H.
    - apply H.
Qed.

Theorem iff_imply: forall P Q: Prop, (P <-> Q) -> (P -> Q).
Proof.
  intros P Q H.
  (** 拆分后，前提_[H]_是命题_[P <-> Q]_ *)
  destruct H.
  (** 拆分后，得到两个前提：
      - H: P -> Q
      - H0: Q -> P *)
  apply H.
Qed.

(************)
(** 习题：  *)
(************)

(** 请在不使用_[tauto]_指令的情况下证明下面结论。*)

Theorem or_dup: forall P: Prop, P \/ P <-> P.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(** * 命题逻辑综合应用 *)

(** 下面是证明“并且”、“或”与“当且仅当”时常用的证明指令汇总与拓展。 

    下面罗列了一些命题逻辑中的常见性质。请有兴趣的读者综合前几节所学内容，在不使用
    _[tauto]_证明指令的限制下完成下面证明。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“假言推理”规则。*)

Theorem modus_ponens: forall P Q: Prop,
  P /\ (P -> Q) -> Q.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“并且”对“或”的分配律。*)

Theorem and_or_distr_l: forall P Q R: Prop,
  P /\ (Q \/ R) <-> P /\ Q \/ P /\ R.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“或”对“并且”的分配律。*)

Theorem or_and_distr_l: forall P Q R: Prop,
  P \/ (Q /\ R) <-> (P \/ Q) /\ (P \/ R).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“并且”对“或”的吸收律。*)

Theorem and_or_absorb: forall P Q: Prop,
  P /\ (P \/ Q) <-> P.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“或”对“并且”的吸收律。*)

Theorem or_and_absorb: forall P Q: Prop,
  P \/ (P /\ Q) <-> P.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“并且”能保持逻辑等价性。*)

Theorem and_congr: forall P1 Q1 P2 Q2: Prop,
  (P1 <-> P2) ->
  (Q1 <-> Q2) ->
  (P1 /\ Q1 <-> P2 /\ Q2).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“或”能保持逻辑等价性。*)

Theorem or_congr: forall P1 Q1 P2 Q2: Prop,
  (P1 <-> P2) ->
  (Q1 <-> Q2) ->
  (P1 \/ Q1 <-> P2 \/ Q2).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“或”能保持逻辑等价性。*)

Theorem imply_congr: forall P1 Q1 P2 Q2: Prop,
  (P1 <-> P2) ->
  (Q1 <-> Q2) ->
  ((P1 -> Q1) <-> (P2 -> Q2)).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“并且”与“如果-那么”之间的关系。提示：必要时可以使用_[assert]_指令证
    明辅助性质。*)

Theorem and_imply: forall P Q R: Prop,
  (P /\ Q -> R) <-> (P -> Q -> R).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明“或”与“如果-那么”之间的关系。提示：必要时可以使用_[assert]_指令证
    明辅助性质。*)

Theorem or_imply: forall P Q R: Prop,
  (P \/ Q -> R) <-> (P -> R) /\ (Q -> R).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(** 本章之后的内容中将介绍关于“任意”、“存在”与“非”的证明方式，在相关逻辑命题的证明过程
    中，涉及命题逻辑的部分将会灵活使用上面介绍的各种证明方式，包括_[tauto]_指令。习题
    中也不再限制使用_[tauto]_指令。 *)


(** * 关于“存在”的证明 *)

(** 当待证明结论形为：“存在一个_[x]_使得...”，那么可以用_[exists]_指明究竟哪个
    _[x]_使得该性质成立。*)

Lemma four_is_even: exists n, 4 = n + n.
Proof. exists 2. lia. Qed.

(************)
(** 习题：  *)
(************)

Lemma six_is_not_prime: exists n, 2 <= n < 6 /\ exists q, n * q = 6.
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(** 当某前提形为：“存在一个_[x]_使得...”，那么可以使用Coq中的_[destruct]_指令进行
    证明。这一证明指令相当于数学证明中的：任意给定一个这样的_[x]_。 *)

Theorem dist_exists_and: forall (X: Type) (P Q: X -> Prop),
  (exists x, P x /\ Q x) -> (exists x, P x) /\ (exists x, Q x).
Proof.
  intros.
  destruct H as [x [HP HQ]].
  (** 拆分后的前提为：
      - HP: P x
      - HQ: Q x *)
  split.
  + (** 第一个分支需要证明: _[exists x0: X, P x0]_，这里Coq系统自动对结论中原先的
        _[exists x]_进行了重命名，将_[x]_改为了_[x0]_避免与_[destruct]_指令产生的
        _[x]_重名。*)
    exists x.
    apply HP.
  + (** 第二个分支需要证明: _[exists x0: X, Q x0]_。*)
    exists x.
    apply HQ.
Qed.

(** 从上面证明可以看出，Coq中可以使用引入模式将一个存在性的命题拆分，并且与其他引入模式
    嵌套使用。*)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem exists_exists: forall (X Y: Type) (P: X -> Y -> Prop),
  (exists x y, P x y) <-> (exists y x, P x y).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem exists_or: forall (X: Type) (P Q: X -> Prop),
  (exists x, P x \/ Q x) <-> (exists x, P x) \/ (exists x, Q x).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)


(** * 关于“任意”的证明 *)

(** 在逻辑中，与“存在”相对偶的量词是“任意”，即Coq中的_[forall]_。其实我们已经在Coq中
    证明了许多关于_[forall]_的命题，最常见的证明方法就是使用_[pose proof]_指令。下面
    是一个简单的例子。*)

Example forall_ex1: forall (X: Type) (P Q R: X -> Prop),
  (forall x: X, P x -> Q x -> R x) ->
  (forall x: X, P x /\ Q x -> R x).
Proof.
  intros X P Q R H x [HP HQ].
  (** 现在的证明环境中有三个前提：
      - HP: P x
      - HQ: Q x
      - H: forall x: X, P x -> Q x -> R x *)
  pose proof H x HP HQ.
  (** 现在的证明环境中有四个前提：
      - HP: P x
      - HQ: Q x
      - H: forall x: X, P x -> Q x -> R x
      - H0: R x *)
  apply H0.
Qed.

(** 有时在证明中想要将前提中的命题与结论一起重新组成推断式或者概称句。这可以通过使用
    _[revert]_指令完成。某种意义上说，_[revert]_指令是_[intros]_指令的反操作。*)

Example forall_ex1_alter_proof: forall (X: Type) (P Q R: X -> Prop),
  (forall x: X, P x -> Q x -> R x) ->
  (forall x: X, P x /\ Q x -> R x).
Proof.
  intros X P Q R H x [HP HQ].
  (** 现在的证明环境中有三个前提：
      - HP: P x
      - HQ: Q x
      - H: forall x: X, P x -> Q x -> R x
      同时结论为：R x *)
  revert x HP HQ.
  (** 通过revert指令HP、HQ与x都从前提中被移除了，而结论则变为了：
      forall x: X, P x -> Q x -> R x *)
  apply H.
Qed.

(** 有时在证明中，我们不需要反复使用一个概称的前提，而只需要使用它的一个特例，此时如果
    能在pose proof指令后删去原命题，能够使得证明目标更加简洁。这可以使用Coq中的
    specialize指令实现。*)

Example forall_ex2: forall (X: Type) (P Q R: X -> Prop),
  (forall x: X, P x /\ Q x -> R x) ->
  (forall x: X, P x -> Q x -> R x).
Proof.
  intros X P Q R H x HP HQ.
  (** 现在的证明环境中有三个前提：
      - HP: P x
      - HQ: Q x
      - H: forall x: X, P x -> Q x -> R x *)
  specialize (H x ltac:(tauto)).
  (** 现在的证明环境中还是只有三个前提：
      - HP: P x
      - HQ: Q x
      - H: R x *)
  apply H.
Qed.

(** 在上面的证明中，specialize指令并没有生成新的前提，而是把原有的前提_[H]_改为了特化
    后的_[R x]_，换言之，原有的概称命题被删去了。在Coq证明中，我们可以灵活使用Coq提供
    的自动化证明指令，例如，在下面证明中，我们使用_[tauto]_指令大大简化了证明。尽管我
    们并不能在一开始就使用_[tauto]_直接完成证明，因为 

        _[forall a: A, P a /\ Q a]_ 

        _[forall a: A, P a]_ 

        _[forall a: A, Q a]_ 

    这三个命题之间的逻辑联系不能仅仅通过命题逻辑推导得到，而要用到概称量词_[forall]_
    的性质。*)

Theorem forall_and: forall (A: Type) (P Q: A -> Prop),
  (forall a: A, P a /\ Q a) <-> (forall a: A, P a) /\ (forall a: A, Q a).
Proof.
  intros.
  split. (** 对_[<->]_拆分。*)
  + intros.
    split. (** 对_[/\]_拆分。*)
    - (** 这一分支的证明目标是：
          - H: forall a: A, P a /\ Q a
          - 结论: forall a: A, P a。*)
      intros a.
      specialize (H a).
      (** 此时证明目标中的前提和结论为：
          - H: P a /\ Q a
          - 结论: P a
          因此就可以用_[tauto]_完成剩余证明了，另外两个分支也是类似。*)
      tauto.
    - (** 这一分支的证明目标是：
          - H: forall a: A, P a /\ Q a
          - 结论: forall a: A, Q a。*)
      intros a.
      specialize (H a).
      tauto.
  + intros [HP HQ].
    (** 这一分支的证明目标是：
        - HP: forall a: A, P a
        - HQ: forall a: A, Q a
        - 结论: forall a: A, P a /\ Q a。*)
    intros a.
    specialize (HP a).
    specialize (HQ a).
    tauto.
Qed.

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem forall_forall : forall (X Y: Type) (P: X -> Y -> Prop),
  (forall x y, P x y) -> (forall y x, P x y).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem forall_iff : forall (X: Type) (P Q: X -> Prop),
  (forall x: X, P x <-> Q x) ->
  ((forall x: X, P x) <-> (forall x: X, Q x)).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem forall_or: forall (A: Type) (P Q: A -> Prop),
  (forall a: A, P a) \/ (forall a: A, Q a) ->
  (forall a: A, P a \/ Q a).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)


(** * 关于“非”的证明 *)

(** “非”是一个命题逻辑连接词，它符合两条重要性质：排中律与矛盾律。排中律说的是，对于任
    意一个命题P，P与非P中必有至少有一个为真。在Coq标准库中排中律称为_[classic]_，下面
    例子展示了在Coq应用排中律的方法。*)

Example not_ex1: forall n m: Z, n < m \/ ~ n < m. 
Proof.
  intros.
  pose proof classic (n < m).
  apply H.
Qed.

(** 矛盾律说的是，对于任意命题P，P与非P不能都为真。在Coq中，如果能从前提中同时推导出P
    与非P就意味着导出了矛盾。这一般可以用_[tauto]_完成证明。*)

Example not_ex2: forall P Q: Prop,
  P -> ~ P -> Q.
Proof. intros. tauto. Qed.

(** 下面是一些关于“非”的重要性质，它们中的一部分可以直接使用_[tauto]_证明。 *)

Theorem not_and_iff: forall P Q: Prop,
  ~ (P /\ Q) <-> ~ P \/ ~ Q.
Proof. intros. tauto. Qed.

Theorem not_or_iff: forall P Q: Prop,
  ~ (P \/ Q) <-> ~ P /\ ~ Q.
Proof. intros. tauto. Qed.

Theorem not_imply_iff: forall P Q: Prop,
  ~ (P -> Q) <-> P /\ ~ Q.
Proof. intros. tauto. Qed.

Theorem double_negation_iff: forall P: Prop,
  ~ ~ P <-> P.
Proof. intros. tauto. Qed.

(** 在证明“非”与量词（_[exists]_， _[forall]_）的关系时，有时可能需要使用排中律。下面
    证明的是，如果不存在一个_[x]_使得_[P x]_成立，那么对于每一个_[x]_而言，都有
    _[~ P x]_成立。证明中，我们根据排中律，对于每一个特定的_[x]_进行分类讨论，究竟是
    _[P x]_成立还是_[~ P x]_成立。如果是后者，那么我们已经完成了证明。如果是前者，则
    可以推出与前提（不存在一个_[x]_使得_[P x]_成立）的矛盾。 *)

Theorem not_exists: forall (X: Type) (P: X -> Prop),
  ~ (exists x: X, P x) -> (forall x: X, ~ P x).
Proof.
  intros.
  (** 此时的前提为_[H: ~ exists x, P x]_ *)
  pose proof classic (P x) as [H0 | H0].
  + assert (exists x: X, P x).
    { exists x. apply H0. }
    (** 上面_[assert]_得到的结论与前提_[H]_矛盾。 *)
    tauto.
  + apply H0.
Qed.

(** 下面再证明，如果并非每一个_[x]_都满足_[P x]_，那么就存在一个_[x]_使得_[~ P x]_成
    立。我们还是选择利用排中律进行证明。*)

Theorem not_forall: forall (X: Type) (P: X -> Prop),
  ~ (forall x: X, P x) -> (exists x: X, ~ P x).
Proof.
  intros.
  pose proof classic (exists x: X, ~ P x) as [H0 | H0].
  + tauto.
  + pose proof not_exists _ _ H0.
    assert (forall x: X, P x <-> ~ ~ P x). {
      intros.
      tauto.
    }
    pose proof forall_iff _ P (fun x => ~ ~ P x) H2.
    tauto.
Qed.

(** 利用前面的结论，我们还可以证明_[not_all]_的带约束版本。*)

Corollary not_forall_imply: forall (X: Type) (P Q: X -> Prop),
  ~ (forall x: X, P x -> Q x) -> (exists x: X, P x /\ ~ Q x).
Proof.
  intros.
  pose proof not_forall _ _ H.
  destruct H0 as [x H0].
  exists x.
  pose proof not_imply_iff (P x) (Q x).
  tauto.
Qed.

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem forall_not: forall (X: Type) (P: X -> Prop),
  (forall x: X, ~ P x) -> ~ (exists x: X, P x).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

(************)
(** 习题：  *)
(************)

(** 请在Coq中证明下面性质：*)

Theorem exists_not: forall (X: Type) (P: X -> Prop),
  (exists x: X, ~ P x) -> ~ (forall x: X, P x).
Admitted. (* 请删除这一行_[Admitted]_并填入你的证明，以_[Qed]_结束。 *)

